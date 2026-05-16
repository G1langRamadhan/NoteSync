//
//  MockTest.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 14/05/26.
//

import Foundation
@testable import NoteSync


class MockAuthService: AuthServiceProtocol {
    
    var mockUser: AuthDataResultModel?
    
    var currentUser: AuthDataResultModel? 
    var shouldThrowError: Bool = false
    var mockError: AuthError = .invalidEmail
    var signedOut: Bool = false
    var observedUser: AuthDataResultModel? = nil
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        if shouldThrowError { throw mockError }
        return mockUser!
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        if shouldThrowError { throw mockError }
        let user = mockUser!
        currentUser = user
        return currentUser!
    }
    
    func signInWithGoogle(googleToken: googleDataResult) async throws -> AuthDataResultModel {
        if shouldThrowError { throw mockError }
        let user = mockUser!
        currentUser = user
        return currentUser!
    }
    
    func signInWithApple(appleDataResult: AppleDataResult) async throws -> AuthDataResultModel {
        if shouldThrowError { throw mockError }
        let user = mockUser!
        currentUser = user
        return currentUser!
    }
    
    func signOut() throws {
        if shouldThrowError { throw mockError }
        signedOut = true  // cukup flag, biarkan mockUser utuh
        currentUser = nil
    }
    
    func observeAuthState(onChange: @escaping (AuthDataResultModel?) -> Void) {
        onChange(observedUser)
    }
}

class MockGoogleSignInHelper: GoogleSignInHelperProtocol {
    
    var shouldThrowError = false
    
    func getGooglDataResult() async throws -> googleDataResult {
        if shouldThrowError {
            throw AuthError.googleSignInFailed
        }
        
        return googleDataResult(tokenId: "mock-token-123578", accessToken: "mock-access-token-1234")
    }
}
