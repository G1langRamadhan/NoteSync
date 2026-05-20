//
//  InvitationService.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation
import Firebase
import FirebaseFirestore


struct UserSearchResult {
    var id: String
    var name: String
    var email: String?
    var photoUrl: String?
}

class FireStoreInvitationService: InvitationProtocol {
    private var db = Firestore.firestore()
    
    private var listener: ListenerRegistration?
    
    private var usersCollection: CollectionReference {
        db.collection("users")
    }
    
    private var invitationCollection: CollectionReference {
        db.collection("invitations")
    }
    
    private var notes = "notes"
    private var collaborators = "collaborators"
    private var invitations = "invitations"
    
    func searchUser(by email: String) async throws -> UserSearchResult {
        let snapShot = try await usersCollection
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments()
        
        // Kalau tidak ada hasil → user tidak terdaftar
        guard let document = snapShot.documents.first else {
            throw CollaboratorError.userNotFound
        }
        
        let data = document.data()
        let id = document.documentID
        guard let email = data["email"] as? String else {
            throw CollaboratorError.invalidData
        }
        
        return UserSearchResult(
            id: id,
            name: "",
            email: email,
            photoUrl: data["photoUrl"] as? String
        )
    }
    
    private func validateInvitation(ownerId: String, toUserId: String, noteId: String) async throws {
        let snapShotInvitationStatus = try await usersCollection
            .document(ownerId)
            .collection(notes)
            .document(noteId)
            .collection(invitations)
            .whereField("toUserId", isEqualTo: toUserId)
            .whereField("status", isEqualTo: InvitationStatus.pending.rawValue)
            .limit(to: 1)
            .getDocuments()
        
        if !snapShotInvitationStatus.documents.isEmpty {
            throw CollaboratorError.invitationAlreadySent
        }
        
        let existingCollab = try await usersCollection
            .document(ownerId)
            .collection(notes)
            .document(noteId)
            .collection(collaborators)
            .document(toUserId)
            .getDocument()
        
        if existingCollab.exists {
            throw CollaboratorError.alreadyCollaborator
        }
    }
    
    func sendInvitation(ownerId: String, to email: String, _ InvitationModel: InvitationModel) async throws {
        let targetUser = try await searchUser(by: email)
        try await validateInvitation(ownerId: ownerId, toUserId: targetUser.id, noteId: InvitationModel.noteId)
        
        let expiresAt = Date().addingTimeInterval(7 * 24 * 60 * 60)
        
        let data: [String: Any] = [
            InvitationDocument.CodingKeys.noteId.rawValue: InvitationModel.noteId,
            InvitationDocument.CodingKeys.title.rawValue: InvitationModel.title,
            InvitationDocument.CodingKeys.status.rawValue: InvitationModel.status.rawValue,
            InvitationDocument.CodingKeys.role.rawValue: InvitationModel.role.rawValue,
            InvitationDocument.CodingKeys.invitationFrom.rawValue: InvitationModel.invitationFrom,
            InvitationDocument.CodingKeys.createdAt.rawValue: FieldValue.serverTimestamp(),
            InvitationDocument.CodingKeys.toEmail.rawValue: InvitationModel.toEmail,
            InvitationDocument.CodingKeys.toUserId.rawValue: targetUser.id,
            InvitationDocument.CodingKeys.ownerId.rawValue: ownerId,
            InvitationDocument.CodingKeys.expiresAt.rawValue: expiresAt,
        ]
        
        try await invitationCollection
            .document(InvitationModel.id)
            .setData(data)
    }
    
    func fetchInvitation(userId: String) async throws -> [InvitationModel] {
        let snapshot = try await invitationCollection
            .whereField("toUserId", isEqualTo: userId)
            .whereField("status", isEqualTo: InvitationStatus.pending.rawValue)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            guard let document = try? document.data(as: InvitationDocument.self) else {
                return nil
            }
            return InvitationModel(from: document)
        }
    }
    
    func acceptInvitation (
        invitationId: String,
        userDetail: AuthDataResultModel?
    ) async throws {
        let _ = try await db.runTransaction { transaction, errorPointer in
            let inviteRef = self.invitationCollection.document(invitationId)
            
            let inviteDoc: DocumentSnapshot
            do {
                inviteDoc = try transaction.getDocument(inviteRef)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
            
            guard let data = inviteDoc.data(),
                  let statusRaw = data[InvitationDocument.CodingKeys.status.rawValue] as? String,
                  let status = InvitationStatus(rawValue: statusRaw),
                  let toUserId = data[InvitationDocument.CodingKeys.toUserId.rawValue] as? String,
                  let roleRaw = data[InvitationDocument.CodingKeys.role.rawValue] as? String,
                  let noteId = data[InvitationDocument.CodingKeys.noteId.rawValue] as? String,
                  let ownerId = data["ownerId"] as? String else  {
                errorPointer?.pointee = CollaboratorError.invalidData as NSError
                return nil
            }
            
            guard status == .pending else {
                errorPointer?.pointee = CollaboratorError.invitationAlreadySent as NSError
                return nil
            }
            
            let noteRef = self.usersCollection
                .document(ownerId)
                .collection(self.notes)
                .document(noteId)
            
            let collaboratorRef = noteRef
                .collection(self.collaborators)
                .document(toUserId)
            
            transaction.updateData(
                [InvitationDocument.CodingKeys.status.rawValue: InvitationStatus.accepted.rawValue],
                forDocument: inviteRef
            )
            
            transaction.updateData(
                ["sharedWith" : FieldValue.arrayUnion([toUserId])],
                forDocument: noteRef
            )
            
            transaction.setData([
                CollaboratorDocument.CodingKeys.id.rawValue: toUserId,
                CollaboratorDocument.CodingKeys.photoProfile.rawValue: userDetail?.photoURL ?? "",
                CollaboratorDocument.CodingKeys.name.rawValue: userDetail?.name ?? "",
                CollaboratorDocument.CodingKeys.role.rawValue: roleRaw
            ], forDocument: collaboratorRef)
            
            return "Undangan berhasil diterima!"
        }
    }
    
    func declineInvitation(invitationId: String) async throws {
        let declineStatus: [String: Any] = [
            "status": InvitationStatus.declined.rawValue
        ]
        
        try await invitationCollection
            .document(invitationId)
            .updateData(declineStatus)
    }
    
    func observerInvitation(userId: String, onChange: @escaping ([InvitationModel]) -> Void) {
        listener?.remove()
        let userInvitationRef = invitationCollection
            .whereField("toUserId", isEqualTo: userId)
            .whereField("status", isEqualTo: InvitationStatus.pending.rawValue)
//            .order(by: "createdAt", descending: true)
        
        print("userInvitationRef: \(userInvitationRef)")
        
        listener = userInvitationRef
            .addSnapshotListener({ snapshot, error in
                guard let snapshot else { return }
                
                let invitations = snapshot.documents.compactMap { doc in
                    guard let invitationData = try? doc.data(as: InvitationDocument.self) else {
                        return nil as InvitationModel?
                    }
                    
                    return InvitationModel(from: invitationData)
                }
                
                onChange(invitations)
            })
    }
    
    func removeListener() {
        listener?.remove()
    }
}

