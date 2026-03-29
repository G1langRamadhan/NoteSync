//
//  AuthError.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import Foundation

enum AuthError: LocalizedError {
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
            //               case .weakPassword:       return "Password terlalu lemah. Minimal 6 karakter."
            //               case .userNotFound:       return "Akun tidak ditemukan."
        case .networkError:       return "Tidak ada koneksi internet."
        case .googleSignInFailed: return "Google Sign-In gagal."
        case .appleSignInFailed:  return "Apple Sign-In gagal"
        case .unknown(let msg):   return msg
        }
    }
}
