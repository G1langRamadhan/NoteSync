//
//  CollaboratorsModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/03/26.
//

import Foundation
import FirebaseFirestore

struct CollaboratorDocument: Codable {
    @DocumentID var id: String?
    var photoProfile: String?
    var name: String
    var role: RoleCollaborator
//    var status: CollaboratorStatus
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoProfile
        case name
        case role
//        case status
    }
}
