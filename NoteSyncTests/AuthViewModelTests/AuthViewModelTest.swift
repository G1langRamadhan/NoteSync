//
//  NoteSyncTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 14/05/26.
//

import XCTest
@testable import NoteSync

// Function Naming Structure: test_[Sturct or Class]_[Conditon]_[Variable or Function]_[Expected Result]

@MainActor
class AuthViewModelTest: XCTestCase {
    var sut: AuthViewModel!
    var mockService : MockAuthService!
    
    override func setUp() async throws  {
        try await super.setUp()
        mockService = MockAuthService()
        mockService.observedUser = nil
        sut = AuthViewModel(authService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
}
