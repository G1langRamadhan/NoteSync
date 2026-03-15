//
//  AuthSevice.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 12/03/26.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn


class AuthService {
    
    @discardableResult
    func createUserWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getCurrentUser() throws -> User {
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.unknown)
        }
        return currentUser
    }
    
    @discardableResult
    func loginWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func loginWithGoogle(googleToken: googleDataResult) async throws -> AuthDataResultModel {
        let authDataResult = GoogleAuthProvider.credential(withIDToken: googleToken.tokenId, accessToken: googleToken.accessToken)
        return try await sigIn(credential: authDataResult)
    }
    
    func sigIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let dataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: dataResult.user)
    }
    
    @discardableResult
    func loginWithApple(appleDataResult: AppleDataResult) async throws -> AuthDataResultModel {
        let authDataResult =  OAuthProvider.appleCredential(
            withIDToken: appleDataResult.tokenId,
            rawNonce: appleDataResult.rawNonce,
            fullName: appleDataResult.fullName
        )
        return try await sigIn(credential: authDataResult)
    }
}

