//
//  LoginEmailAccountTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import XCTest
@testable import NoteSync

extension AuthViewModelTest {
    func test_authViewModel_whenSigninWithEmailSuccess_loginEmailAccount_shouldReturnUserData() async throws {
        let user = AuthDataResultModel(
            id: "testingId123",
            email: "testLogin@gmail.com",
            name: "John Doe",
            photoURL: nil,
            phoneNumber: nil
        )
        
        mockService.mockUser = user
        
        sut.email = "testLogin@gmail.com"
        sut.password = "123456"
        
        try await sut.loginEmailAccount()
        
        XCTAssertEqual(sut.currentUser?.email, "testLogin@gmail.com")
        XCTAssertEqual(sut.currentUser?.name, "John Doe")
        XCTAssertEqual(sut.authState, .authenticated)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        
    }
    
    func test_authViewModel_whenEmailIsInvalid_loginEmailAccount_shouldReturnError() async throws {
        mockService.shouldThrowError = true
        mockService.mockError = .invalidEmail
        sut.email = ""
        sut.password = "123456"
        
        try await sut.loginEmailAccount()
        
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertEqual(sut.errorMessage, AuthError.invalidEmail.errorDescription)
        XCTAssertNil(sut.currentUser)
    }
    
    func test_authViewModel_whenPasswordIsInvalid_loginEmailAccount_shouldReturnError() async throws {
        mockService.shouldThrowError = true
        mockService.mockError = .wrongPassword
        sut.email = "testLogingmail.com"
        sut.password = ""
        
        try await sut.loginEmailAccount()
        
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertEqual(sut.errorMessage, AuthError.wrongPassword.errorDescription)
        XCTAssertNil(sut.currentUser)
    }
}
