//
//  InvitationProtocol.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation

protocol InvitationProtocol {
    func searchUser(by email: String) async throws -> UserSearchResult
    func sendInvitation(
        ownerId: String, to email: String, _ InvitationModel: InvitationModel
    ) async throws
    
    func fetchInvitation(userId: String) async throws -> [InvitationModel]
    func acceptInvitation(
        invitationId: String,
        userDetail: AuthDataResultModel?
    ) async throws
    func declineInvitation(ownerId: String, invitationId: String, noteId: String) async throws
    func observerInvitation(userId: String, onChange: @escaping ([InvitationModel]) -> Void)
    func removeListener()
}
