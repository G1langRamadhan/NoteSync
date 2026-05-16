//
//  FirestoreCollaboratorService.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 22/03/26.
//

import Foundation
import FirebaseFirestore
import Firebase

class FirestoreCollaboratorService: CollaboratorProtocol {
    
    private var db = Firestore.firestore()
    private var collaborators = "collaborators"
    private var notes = "notes"
    
    private var userCollection: CollectionReference {
        db.collection("users")
    }
    
    private var listener: ListenerRegistration?
    
    func fetchCollaborators(userId: String, noteId: String) async throws -> [CollaboratorModel] {
        let userCollaboratorRef = userCollection
            .document(userId)
            .collection(notes)
            .document(noteId)
            .collection(collaborators)

        let snapshot = try await userCollaboratorRef
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            guard let data = try? document.data(as: CollaboratorDocument.self) else {
                return nil
            }
            
            return CollaboratorModel(from: data)
        }
    }
    
    func updateCollaborators(userId: String, noteId: String, collaborator: CollaboratorModel) async throws {
        let data: [String: Any] = [
            "name": collaborator.name,
            "role": collaborator.role.rawValue
        ]
        
        try await userCollection
            .document(userId)
            .collection(notes)
            .document(noteId)
            .collection(collaborators)
            .document(collaborator.id)
            .updateData(data)
    }
    
    func deleteCollaborators(userId: String, noteId: String, collaboratorId: String) async throws {
        try await userCollection
            .document(userId)
            .collection(notes)
            .document(noteId)
            .collection(collaborators)
            .document(collaboratorId)
            .delete()
    }
    
    func observeCollaborators(userId: String, noteId: String, onChange: @escaping ([CollaboratorModel]) -> Void) {
        listener?.remove()
        
        let collaboratorsRef = userCollection
            .document(userId)
            .collection(notes)
            .document(noteId)
            .collection(collaborators)
        
        listener = collaboratorsRef
            .addSnapshotListener({ snapshot, error in
                guard let snapshot else {
                    print("⚠️ Snapshot kosong.")
                    return
                }
                
                let collaborators = snapshot.documents.compactMap { doc in
                    guard let collDoc = try? doc.data(as: CollaboratorDocument.self) else {
                        return nil as CollaboratorModel?
                    }
                    
                    return CollaboratorModel(from: collDoc)
                }
                onChange(collaborators)
            })
    }
    
    func removeListener() {
        listener?.remove()
        listener = nil
    }
    
    deinit {
        removeListener()
    }
}
