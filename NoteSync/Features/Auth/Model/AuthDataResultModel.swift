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

struct AuthDataResultModel {
    var email: String?
    var name: String?
    var photoURL: String?
    var phoneNumber: String?
    
    init(user: User) {
        self.email = user.email
        self.name = user.displayName ?? "User"
        self.photoURL = user.photoURL?.absoluteString
        self.phoneNumber = user.phoneNumber
    }
}
