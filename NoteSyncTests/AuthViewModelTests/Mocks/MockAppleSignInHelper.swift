//
//  MockAppleSignInHelper.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import Foundation
@testable import NoteSyncApp

class MockAppleSignInHelper: AppleSigInHelperProtocol {
    
    var shouldThrowError: Bool = false
    var helperCallCount: Int = 0
    
    func signInWithApple () async throws -> AppleDataResult {
        helperCallCount += 1
        if shouldThrowError {
            throw AuthError.appleSignInFailed
        }
        
        return AppleDataResult(tokenId: "testing id", rawNonce: "nonceRawtesting", fullName: PersonNameComponents())
    }
}
