//
//  InvitationModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation
import FirebaseFirestore

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
    var role: Role
    var toEmail: String
    var invitationFrom: String
    var toUserId: String = ""
    var status: InvitationStatus = .pending
    var createdAt: Date = Date()
    var expiresAt: Date = Date().addingTimeInterval(7 * 24 * 60 * 60)
    
    init(noteId: String, title: String, role: Role, invitationFrom: String, toEmail: String) {
        self.id = UUID().uuidString
        self.noteId = noteId
        self.title = title
        self.role = role
        self.invitationFrom = invitationFrom
        self.toEmail = toEmail
    }
    
    init(from document: InvitationDocument) {
        self.id = document.id ?? UUID().uuidString
        self.noteId = document.noteId
        self.title = document.title
        self.status = document.status
        self.role = document.role
        self.invitationFrom = document.invitationFrom
        self.toEmail = document.toEmail
        self.toUserId = document.toUserId
        self.createdAt = document.createdAt.dateValue()
        self.expiresAt = document.expiresAt.dateValue()
    }
}


