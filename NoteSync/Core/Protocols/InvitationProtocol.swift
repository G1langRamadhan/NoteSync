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
        to email: String,
        noteId: String,
        noteTitle: String,
        role: Role
    ) async throws
    
    func fetchInvitation(userId: String) async throws -> [InvitationModel]
    func acceptInvitation(invitationId: String, noteId: String) async throws
    func declineInvitation(invitationId: String) async throws
}
