//
//  CollaboratorError.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 22/03/26.
//

import Foundation

enum CollaboratorError: LocalizedError {
    case userNotFound
    case invalidData
    case invitationAlreadySent
    case alreadyCollaborator
    case invitationExpired
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User dengan email ini tidak ditemukan."
        case .invalidData:
            return "Data tidak valid."
        case .invitationAlreadySent:
            return "Undangan sudah dikirim ke user ini."
        case .alreadyCollaborator:
            return "User ini sudah menjadi kolaborator."
        case .invitationExpired:
            return "Undangan sudah tidak berlaku."
        case .permissionDenied:
            return "Kamu tidak punya akses untuk melakukan ini."
        }
    }
}
