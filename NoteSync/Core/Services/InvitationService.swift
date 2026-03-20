//
//  InvitationService.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation
import Firebase


struct UserSearchResult {
    var id: String
    var name: String
    var email: String?
    var photoUrl: String?
}

class InvitationService: InvitationProtocol {
    private var db = Firestore.firestore()
    
    private var usersCollection: CollectionReference {
        db.collection("users")
    }
    
    private var notesCollection: CollectionReference {
        db.collection("notes")
    }
    
    private var invitationsCollection: CollectionReference {
        db.collection("invitations")
    }
    
    func searchUser(by email: String) async throws -> UserSearchResult {
        let snapShot = try await usersCollection
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments()
        
        guard let document = snapShot.documents.first else {
            throw AuthError.emailAlreadyInUse
        }
        
        let data = document.data()
        
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let email = data["email"] as? String else {
            throw AuthError.emailAlreadyInUse
        }
        
        return UserSearchResult(
            id: id,
            name: name,
            email: email,
            photoUrl: data["photoUrl"] as? String
        )
        
    }
    
    func sendInvitation(to email: String, noteId: String, noteTitle: String, role: Role) async throws {
        
    }
    
    func fetchInvitation(userId: String) async throws -> [InvitationModel] {
        let snapShot = try await invitationsCollection
            .whereField("toEmail", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        
        
        return snapShot.documents.compactMap { document in
            mappingInvitationModel(data: document.data())
        }
    }
    
    func acceptInvitation(invitationId: String, noteId: String) async throws {
        
    }
    
    func declineInvitation(invitationId: String) async throws {
        
    }
    
    func mappingInvitationModel(data: [String : Any]) -> InvitationModel? {
        guard
            let id = data["id"] as? String,
            let noteId = data["noteId"] as? String,
            let title = data["title"] as? String,
            let statusRaw = data["statusRaw"] as? String,
            let status = InvitationStatus(rawValue: statusRaw),
            let roleRaw = data["roleRaw"] as? String,
            let role = Role(rawValue: roleRaw),
            let createdAt = data["createdAt"] as? Date,
            let toEmail = data["toEmail"] as? String,
            let userId = data["userId"] as? String,
            let expiresAt = data["expiresAt"] as? Date,
            let invitationFrom = data["sendderInvitation"] as? String
        else {
            return nil
        }
        
        return InvitationModel(
            id: id,
            noteId: noteId,
            title: title,
            status: status,
            role: role,
            invitationFrom: invitationFrom,
            createdAt: createdAt,
            toEmail: toEmail,
            toUserId: userId,
            expiresAt: expiresAt
        )
    }
}

