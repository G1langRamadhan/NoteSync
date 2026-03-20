//
//  NoteServiceProtocol.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 17/03/26.
//

import Foundation
import FirebaseFirestore

protocol NoteServiceProtocol {
    func fetchNotes(userId: String) async throws -> [NoteModel]
    func createNote(_ noteModel: NoteModel, _ userId: String) async throws
    func updateNote(_ noteModel: NoteModel) async throws
    func deleteNote(id: String) async throws
    
    func observer(userId: String, onChange: @escaping ([NoteModel]) -> Void)
    func removeListener()
}
