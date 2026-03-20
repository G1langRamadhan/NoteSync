//
//  InvitationModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation

enum InvitationStatus: String, Codable {
    case pending
    case accepted
    case declined

    var displayText: String {
        switch self {
        case .pending:  return "Pending"
        case .accepted: return "Accepted"
        case .declined: return "Declined"
        }
    }
}

enum Role: String, Codable {
    case editor
    case viewer
    
    var displayText: String {
        switch self {
        case .editor:
            return "Editor"
        case .viewer:
            return "Viewer"
        }
    }
}

struct InvitationModel: Identifiable {
    var id: String
    var noteId: String
    var title: String
    var status: InvitationStatus
    var role: Role
    var invitationFrom: String
    var createdAt: Date
    var toEmail: String
    var toUserId: String
    var expiresAt: Date
}


