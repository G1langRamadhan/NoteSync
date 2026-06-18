//
//  MockGoogleSignInHelper.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import Foundation
@testable import NoteSyncApp

class MockGoogleSignInHelper: GoogleSignInHelperProtocol {
    
    var shouldThrowError = false
    
    func getGooglDataResult() async throws -> googleDataResult {
        try await Task.sleep(nanoseconds: 100_000_000)
        if shouldThrowError {
            throw AuthError.googleSignInFailed
        }
        
        return googleDataResult(tokenId: "mock-token-123578", accessToken: "mock-access-token-1234")
    }
}
