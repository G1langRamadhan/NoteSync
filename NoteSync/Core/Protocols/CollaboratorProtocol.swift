//
//  CollaboratorModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation

protocol CollaboratorProtocol {
    func fetchCollaborators(userId: String, noteId: String) async throws -> [CollaboratorModel]
    func updateCollaborators(userId: String, noteId: String, collaborator: CollaboratorModel) async throws
    func deleteCollaborators(userId: String, noteId: String, collaboratorId: String) async throws
    
    func observeCollaborators(userId: String, noteId: String, onChange: @escaping ([CollaboratorModel]) -> Void)
    func removeListener()
}
