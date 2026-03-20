//
//  CollaboratorModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation

protocol CollaboratorProtocol {
    func fetchCollaborators(noteId: String) async throws -> [CollaboratorModel]
    func updateCollaborators(collaborator: CollaboratorModel) async throws
    func deleteCollaborators(collaboratorId: String) async throws
    
    func observeCollaborators(userId: String, onChange: @escaping ([CollaboratorModel]) -> Void)
    func removeListener()
}
