//
//  InvitationViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/05/26.
//

import Foundation
import Combine

class InvitationInboxViewModel: ObservableObject {
    @Published var invitations: [InvitationModel] = []
    @Published var pendingInvitations: [InvitationModel] = []
    private let invitationProtocol: InvitationProtocol
    
    private var userInfo: AuthDataResultModel?
    private let userId: String
    
    init(userId: String, userInfo: AuthDataResultModel?, invitationProtocol: InvitationProtocol = FireStoreInvitationService()) {
        self.invitationProtocol = invitationProtocol
        self.userInfo = userInfo
        self.userId = userId
        observerInvitation()
        Task {
            await fetchInvitation()
        }
    }
    
    func updateUserInfo(_ userInfo: AuthDataResultModel?) {
        self.userInfo = userInfo
    }
    
    func acceptInvitation(invitation: InvitationModel) async  {
        do {
            try await invitationProtocol.acceptInvitation(invitationId: invitation.id, userDetail: userInfo)
        } catch {
            print("accept invitation error: \(error)")
        }
    }
    
    func fetchInvitation() async  {
        print("call fetch invitaion")
        do {
            pendingInvitations = try await invitationProtocol.fetchInvitation(userId: userId)
            print("owner id: \(userId)")
            print("pending invitations: \(pendingInvitations)")
        } catch  {
            print("Error when fetch pending invitation: \(error)")
        }
    }
    
    func declineInvitation(invitation: InvitationModel) async {
        do {
            try await invitationProtocol.declineInvitation(invitationId: invitation.id)
        } catch {
            print("decline invitation error: \(error)")
           
        }
    }
    
    func observerInvitation() {
        invitationProtocol.observerInvitation(userId: userId) { [weak self] invitation in
            self?.invitations = invitation
        }
    }
    
    deinit {
        invitationProtocol.removeListener()
    }
}
