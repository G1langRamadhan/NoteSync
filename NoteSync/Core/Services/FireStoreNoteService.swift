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
    private var collection: CollectionReference {
        db.collection("notes")
    }
    private var listener: ListenerRegistration?
    
    
    func fetchNotes(userId: String) async throws -> [NoteModel] {
        let snapShot = try await collection
            .whereField(NoteDocument.CodingKeys.ownerId.rawValue, isEqualTo: userId)
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
            "lastUpdateServer": FieldValue.serverTimestamp()
        ]

        try await collection
            .document(noteModel.id)
            .setData(data)
    }
    
    func updateNote(_ noteModel: NoteModel) async throws {
        let data: [String: Any] = [
            NoteDocument.CodingKeys.title.rawValue : noteModel.title,
            NoteDocument.CodingKeys.body.rawValue : noteModel.body,
            NoteDocument.CodingKeys.dateCreated.rawValue : noteModel.dateCreated,
            NoteDocument.CodingKeys.lastUpdateLocal.rawValue : noteModel.lastUpdateLocal,
            "lastUpdateServer": FieldValue.serverTimestamp()
        ]
        
        try await collection.document(noteModel.id).updateData(data)
    }
    
    func deleteNote(id: String) async throws{
        try await collection
            .document(id)
            .delete()
    }
    
    func observer(userId: String, onChange: @escaping ([NoteModel]) -> Void) {
        listener?.remove()
        listener = collection
            .whereField(NoteDocument.CodingKeys.ownerId.rawValue, isEqualTo: userId)
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
    
    func removeListener() {
        listener?.remove()
        listener = nil
    }
    
    deinit {
        removeListener()
    }
    
}
