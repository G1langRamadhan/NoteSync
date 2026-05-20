//
//  InvitationModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation
import FirebaseFirestore

struct InvitationDocument: Codable {
    @DocumentID var id: String?
    var noteId: String
    var title: String
    var status: InvitationStatus
    var role: RoleCollaborator
    var invitationFrom: String
    var toEmail: String
    var ownerId: String
    var toUserId: String
    var createdAt: Timestamp
    var expiresAt: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id
        case noteId
        case title
        case status
        case role
        case invitationFrom
        case createdAt
        case toEmail
        case ownerId
        case toUserId
        case expiresAt
    }
}


