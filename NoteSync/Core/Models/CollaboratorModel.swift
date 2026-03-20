//
//  CollaboratorsModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation

enum CollaboratorStatus: String, Codable {
    case online
    case active
    case offline
    
    var displayText: String {
        switch self {
        case .online:
            return "Online"
        case .active:
            return "Active"
        case .offline:
            return "Offline"
        }
    }
}


struct CollaboratorModel: Identifiable {
    var id: String
    var photoProfile: String?
    var name: String
    var role: Role
    var status: CollaboratorStatus
}
