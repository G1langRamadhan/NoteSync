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
    
    private var myNotesListener: ListenerRegistration?
    private var sharedNotesListener: ListenerRegistration?
    
    
//    func fetchNotes(userId: String) async throws -> [NoteModel] {
//        let userNotesRef = userCollections.document(userId).collection("notes")
//        
//        let snapShot = try await userNotesRef
//            .order(by: NoteDocument.CodingKeys.lastUpdateLocal.rawValue, descending: true)
//            .getDocuments()
//        
//        return snapShot.documents.compactMap { document in
//            guard let noteDoc = try? document.data(as: NoteDocument.self) else {
//                return nil
//            }
//            return NoteModel(from: noteDoc)
//        }
//    }
    
    func createNote(_ noteModel: NoteModel, _ userId: String) async throws {
        let data: [String: Any] = [
            NoteDocument.CodingKeys.title.rawValue : noteModel.title,
            NoteDocument.CodingKeys.body.rawValue : noteModel.body,
            NoteDocument.CodingKeys.ownerId.rawValue : userId,
            NoteDocument.CodingKeys.dateCreated.rawValue : noteModel.dateCreated,
            NoteDocument.CodingKeys.lastUpdateLocal.rawValue : noteModel.lastUpdateLocal,
            NoteDocument.CodingKeys.sharedWith.rawValue : [],
            NoteDocument.CodingKeys.pinned.rawValue : false,
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
            NoteDocument.CodingKeys.pinned.rawValue: noteModel.pinned,
            "lastUpdateServer": FieldValue.serverTimestamp()
        ]
        
        try await userCollections.document(userId)
            .collection("notes")
            .document(noteModel.id)
            .updateData(data)
    }
    
    func updateNoteSharedNote(_ noteModel: NoteModel/*, _ userId: String*/) async throws {
        let data: [String: Any] = [
            NoteDocument.CodingKeys.title.rawValue : noteModel.title,
            NoteDocument.CodingKeys.body.rawValue : noteModel.body,
            NoteDocument.CodingKeys.dateCreated.rawValue : noteModel.dateCreated,
            NoteDocument.CodingKeys.lastUpdateLocal.rawValue : noteModel.lastUpdateLocal,
            "lastUpdateServer": FieldValue.serverTimestamp()
        ]
        
//        let userNotesRef = try await db.collectionGroup("notes")
//            .whereField("id", isEqualTo: noteModel.id)
//            .whereField("sharedWith", arrayContains: userId)
//            .getDocuments()
//        
//        for document in userNotesRef.documents {
//            return try await document.reference.updateData(data)
//        }
            
        
        try await userCollections
            .document(noteModel.ownerId)
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
        myNotesListener?.remove()
        
        let userNotesRef = userCollections.document(userId).collection("notes")
        
       myNotesListener = userNotesRef
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
        sharedNotesListener?.remove()
            
        print("userid observer shared notes: \(userId)")
        sharedNotesListener = userNotesRef
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
        myNotesListener?.remove()
        myNotesListener = nil
        sharedNotesListener?.remove()
        sharedNotesListener = nil
    }
    
    deinit {
        removeListener()
    }
    
}
