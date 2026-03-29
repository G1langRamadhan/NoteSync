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
    @Published var invitations: [InvitationModel] = []
    @Published var isLoading: Bool = false

    private let collaboratorProtocol: CollaboratorProtocol
    private let invitationProtocol: InvitationProtocol
    private var noteModel: NoteModel
    private var userInfo: AuthDataResultModel?
    var userId: String

    init(userId: String, note: NoteModel, userInfo: AuthDataResultModel?, collaboratorProtocol: CollaboratorProtocol = FirestoreCollaboratorService(), invitationProtocol: InvitationProtocol = FireStoreInvitationService()) {
        self.collaboratorProtocol = collaboratorProtocol
        self.invitationProtocol = invitationProtocol
        self.userId = userId
        self.userInfo = userInfo
        noteModel = note
        observer()
        observerInvitation()
    }
    
    func sentInvitation(to email: String) async throws {
        let invitationForm = InvitationModel(noteId: noteModel.id, title: noteModel.title, role: .editor, invitationFrom: "satuduatiga@gmail.com", toEmail: email)
        do {
            try await invitationProtocol.sendInvitation(ownerId: userId, to: email, invitationForm)
        } catch {
            print("send invitation error: \(error)")
               throw error
        }
    }
    
    func acceptInvitation(invitation: InvitationModel) async  {
        do {
            try await invitationProtocol.acceptInvitation(invitationId: invitation.id, userDetail: userInfo)
        } catch {
            print("accept invitation error: \(error)")
              
        }
    }
    
    func declineInvitation(invitation: InvitationModel) async {
        do {
            try await invitationProtocol.declineInvitation(ownerId: userId, invitationId: invitation.id, noteId: noteModel.id)
        } catch {
            print("decline invitation error: \(error)")
           
        }
    }
    
    func updateCollaborator(colloratorModel: CollaboratorModel) async throws {
        do {
            try await collaboratorProtocol.updateCollaborators(userId: userId, noteId: noteModel.id, collaborator: colloratorModel)
        } catch {
                    
        }
    }
    
    func deleteCollaborator(collaboratorId: String) async throws {
        do {
            try await collaboratorProtocol.deleteCollaborators(userId: userId, noteId: noteModel.id, collaboratorId: collaboratorId)
        } catch {
            
        }
    }
    
    func observer() {
        collaboratorProtocol.observeCollaborators(userId: userId, noteId: noteModel.id) { [weak self] collaborator in
            print("collaboratorsss: \(collaborator)")
            self?.collaborators = collaborator
        }
    }
    
    func observerInvitation() {
        print("userId obser invitation: \(userId)")
        invitationProtocol.observerInvitation(userId: userId) { [weak self] invitation in
            self?.invitations = invitation
        }
    }
    
    deinit {
        collaboratorProtocol.removeListener()
        invitationProtocol.removeListener()
    }
}
