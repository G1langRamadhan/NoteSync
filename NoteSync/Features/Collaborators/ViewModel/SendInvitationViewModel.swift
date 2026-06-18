//
//  SendInvitationViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/05/26.
//

import Foundation
import Combine

struct NoteInvitationContext {
    let noteId: String
    let noteTitle: String
    let ownerId: String
}

class SendInvitationViewModel: ObservableObject {
    @Published var isSending: Bool = false
    @Published var pendingInvitations: [InvitationModel] = []
    @Published var errorMessage: String?
    
    private let invitationProtocol: InvitationProtocol
    private let context: NoteInvitationContext
    private let currentUser: AuthDataResultModel?
    
    init(
        context: NoteInvitationContext,
        currentUser: AuthDataResultModel?,
        invitationProtocol: InvitationProtocol = FireStoreInvitationService()
    ) {
        self.context = context
        self.currentUser = currentUser
        self.invitationProtocol = invitationProtocol
        Task {
            await fetchInvitation()
        }
    }
    
    func sendInvitation(to email: String, role: RoleCollaborator = .viewer) async throws {
        isSending = true
        errorMessage = nil
        defer { isSending = false }
        
        let invitationForm = InvitationModel(
            noteId: context.noteId,
            title: context.noteTitle,
            role: role,
            invitationFrom: currentUser?.email ?? "",
            toEmail: email
        )
        
        do {
            try await invitationProtocol.sendInvitation(ownerId: context.ownerId, to: email, invitationForm)
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func fetchInvitation() async  {
        guard let userId = currentUser?.id else { return }
        do {
            pendingInvitations = try await invitationProtocol.fetchInvitation(userId: userId)
        } catch  {
        }
    }
}
