//
//  AuthError.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import Foundation

enum AuthError: LocalizedError, Equatable {
    static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidEmail, .invalidEmail): return true
        case (.wrongPassword, .wrongPassword): return true
        case (.emailAlreadyInUse, .emailAlreadyInUse): return true
        case (.networkError, .networkError): return true
        case (.googleSignInFailed, .googleSignInFailed): return true
        case (.appleSignInFailed, .appleSignInFailed): return true
        case (.unknown(let lMessage), .unknown(let rMessage)):
            return lMessage == rMessage
        default : return false
            
        }
    }
    
    case invalidEmail
    case wrongPassword
    case emailAlreadyInUse
    //    case weakPassword
    //    case userNotFound
    case networkError
    case googleSignInFailed
    case appleSignInFailed
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:       return "Format email tidak valid."
        case .wrongPassword:      return "Password salah. Coba lagi."
        case .emailAlreadyInUse:  return "Email ini sudah terdaftar."
        case .networkError:       return "Tidak ada koneksi internet."
        case .googleSignInFailed: return "Google Sign-In gagal."
        case .appleSignInFailed:  return "Apple Sign-In gagal"
        case .unknown(let msg):   return msg
        }
    }
}
