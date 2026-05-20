//
//  CollaboratorsViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 28/03/26.
//

import Foundation
import SwiftUI
import Combine

class CollaboratorsViewModel: ObservableObject {
    @Published var collaborators: [CollaboratorModel] = []
    @Published var isLoading: Bool = false
    @Published var ownerNote: AuthDataResultModel?

    private let collaboratorProtocol: CollaboratorProtocol
    var noteModel: NoteModel
    private var userId: String

    init(note: NoteModel, userId: String, collaboratorProtocol: CollaboratorProtocol = FirestoreCollaboratorService()) {
        self.collaboratorProtocol = collaboratorProtocol
        noteModel = note
        self.userId = userId
        observer()
    }
    
    func fetchOwnerNote() async throws {
        do {
            ownerNote = try await collaboratorProtocol.fetchOwnerNote(ownerId: noteModel.ownerId)
        } catch {
            
        }
    }
    
    func updateCollaborator(colloratorModel: CollaboratorModel) async throws {
        do {
            print("collaborators update value: \(colloratorModel)")
            try await collaboratorProtocol.updateCollaborators(ownerId: noteModel.ownerId, noteId: noteModel.id, collaborator: colloratorModel)
        } catch {
                    
        }
    }
    
    func deleteCollaborator(collaboratorId: String) async throws {
        do {
            try await collaboratorProtocol.deleteCollaborators(ownerId: noteModel.ownerId, noteId: noteModel.id, collaboratorId: collaboratorId)
        } catch {
            
        }
    }
    
    func observer() {
        collaboratorProtocol.observeCollaborators(ownerId: noteModel.ownerId, noteId: noteModel.id) { [weak self] collaborator in
            print("collaboratorsss: \(collaborator)")
            self?.collaborators = collaborator
        }
    }
    
    
    deinit {
        collaboratorProtocol.removeListener()
    }
}
