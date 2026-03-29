//
//  CollaboratorsModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation
import FirebaseFirestore

struct CollaboratorModel: Identifiable {
    var id: String
    var photoProfile: String?
    var name: String
    var role: Role
//    var status: CollaboratorStatus
    
    init(photoProfile: String? = nil, name: String, role: Role) {
        self.id = UUID().uuidString
        self.photoProfile = photoProfile
        self.name = name
        self.role = role
//        self.status = status
    }
    
    init(from document: CollaboratorDocument) {
        self.id = document.id ?? UUID().uuidString
        self.name = document.name
        self.role = document.role
//        self.status = document.status
        self.photoProfile = document.photoProfile
    }
}

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

struct Collaborators: Codable {
    var id: String
    var name: String?
    var email: String?
    var photoURL: String?
    
    init(user: AuthDataResultModel) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.photoURL = user.photoURL
    }
}
