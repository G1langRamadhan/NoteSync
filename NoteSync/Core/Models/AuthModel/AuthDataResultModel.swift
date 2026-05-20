//
//  AuthDataResultMode.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 12/03/26.
//

import Foundation
import FirebaseAuth


enum Field: String, CaseIterable {
    case email = "Email"
    case password = "Password"
    case fullName = "Full Name"
    case passwordConfirmation = "Password Confirmation"
}

struct AuthDataResultModel: Decodable{
    var id: String
    var email: String?
    var name: String?
    var photoURL: String?
    var phoneNumber: String?
    
    init(user: User) {
        self.id = user.uid
        self.email = user.email
        self.name = user.displayName ?? "User"
        self.photoURL = user.photoURL?.absoluteString
        self.phoneNumber = user.phoneNumber
    }
    
    init(id: String, email: String? = nil, name: String? = nil,
         photoURL: String? = nil, phoneNumber: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.photoURL = photoURL
        self.phoneNumber = phoneNumber
    }
}
