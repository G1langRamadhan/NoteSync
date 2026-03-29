//
//  FireStoreNoteService.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 18/03/26.
//

import Foundation
import Firebase
import FirebaseFirestore


class FireStoreNoteService: NoteServiceProtocol {
    
    private var db = Firestore.firestore()
    
    private var userCollections: CollectionReference {
        db.collection("users")
    }
    
    private var listener: ListenerRegistration?
    
    
    func fetchNotes(userId: String) async throws -> [NoteModel] {
        let userNotesRef = userCollections.document(userId).collection("notes")
        
        let snapShot = try await userNotesRef
            .order(by: NoteDocument.CodingKeys.lastUpdateLocal.rawValue, descending: true)
            .getDocuments()
        
        return snapShot.documents.compactMap { document in
            guard let noteDoc = try? document.data(as: NoteDocument.self) else {
                return nil
            }
            return NoteModel(from: noteDoc)
        }
    }
    
    func createNote(_ noteModel: NoteModel, _ userId: String) async throws {
        let data: [String: Any] = [
            NoteDocument.CodingKeys.title.rawValue : noteModel.title,
            NoteDocument.CodingKeys.body.rawValue : noteModel.body,
            NoteDocument.CodingKeys.ownerId.rawValue : userId,
            NoteDocument.CodingKeys.dateCreated.rawValue : noteModel.dateCreated,
            NoteDocument.CodingKeys.lastUpdateLocal.rawValue : noteModel.lastUpdateLocal,
            NoteDocument.CodingKeys.sharedWith.rawValue : [],
            "lastUpdateServer": FieldValue.serverTimestamp()
        ]
        
        try await userCollections
            .document(userId)
            .collection("notes")
            .document(noteModel.id)
            .setData(data)
    }
    
    func updateNote(_ noteModel: NoteModel, _ userId: String) async throws {
        let data: [String: Any] = [
            NoteDocument.CodingKeys.title.rawValue : noteModel.title,
            NoteDocument.CodingKeys.body.rawValue : noteModel.body,
            NoteDocument.CodingKeys.dateCreated.rawValue : noteModel.dateCreated,
            NoteDocument.CodingKeys.lastUpdateLocal.rawValue : noteModel.lastUpdateLocal,
            "lastUpdateServer": FieldValue.serverTimestamp()
        ]
        
        try await userCollections.document(userId)
            .collection("notes")
            .document(noteModel.id)
            .updateData(data)
    }
    
    func deleteNote(noteId: String, userId: String) async throws{
        try await userCollections
            .document(userId)
            .collection("notes")
            .document(noteId).delete()
    }
    
    func observer(userId: String, onChange: @escaping ([NoteModel]) -> Void) {
        listener?.remove()
        
        let userNotesRef = userCollections.document(userId).collection("notes")
        
       listener = userNotesRef
            .order(by: NoteDocument.CodingKeys.lastUpdateLocal.rawValue, descending: true)
            .addSnapshotListener{ snapshot, error in
                guard let snapshot else {
                    return
                }
                
               let notes = snapshot.documents.compactMap { doc in
                    guard let noteDoc = try? doc.data(as: NoteDocument.self) else {
                        return nil as NoteModel?
                    }
                    
                   return NoteModel(from: noteDoc)
                }
                onChange(notes)
            }
    }
    
    func observeSharedNote(userId: String, onChange: @escaping ([NoteModel]) -> Void) {
        let userNotesRef = db.collectionGroup("notes")
            
        print("userid observer shared notes: \(userId)")
        listener = userNotesRef
            .whereField("sharedWith", arrayContains: userId)
            .addSnapshotListener({ snapshot, error in
                guard let snapshot else {
                    return
                }
                
                let sharedNotes = snapshot.documents.compactMap { doc in
                    guard let noteDoc = try? doc.data(as: NoteDocument.self) else {
                        return nil as NoteModel?
                    }
                    
                    return NoteModel(from: noteDoc)
                }
                
                onChange(sharedNotes)
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
