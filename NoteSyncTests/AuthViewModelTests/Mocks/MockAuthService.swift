//
//  MockAuthService.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
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
    
    enum MockError: Error {
        case missingMockUser
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        try await Task.sleep(for: .milliseconds(100))
        if shouldThrowError { throw mockError }
        guard let mockUser else {
            throw MockError.missingMockUser
        }
        return mockUser
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        if shouldThrowError { throw mockError }
        guard let mockUser else {
            throw MockError.missingMockUser
        }
        currentUser = mockUser
        return mockUser
    }
    
    func signInWithGoogle(googleToken: googleDataResult) async throws -> AuthDataResultModel {
        if shouldThrowError { throw mockError }
        guard let mockUser else {
            throw MockError.missingMockUser
        }
        currentUser = mockUser
        return mockUser
    }
    
    func signInWithApple(appleDataResult: AppleDataResult) async throws -> AuthDataResultModel {
        if shouldThrowError { throw mockError }
        guard let mockUser else {
            throw MockError.missingMockUser
        }
        currentUser = mockUser
        return mockUser
    }
    
    func signOut() throws {
        if shouldThrowError { throw mockError }
        signedOut = true  // cukup flag, biarkan mockUser utuh
        currentUser = nil
    }
    
    func observeAuthState(onChange: @escaping @MainActor (AuthDataResultModel?) -> Void) {
        MainActor.assumeIsolated {
            onChange(self.observedUser)
        }
    }
}
