//
//  SignInWithGoogleTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import XCTest
@testable import NoteSync

extension AuthViewModelTest {
    func test_authViewModel_whenSignInWithGoogleSuccess_signInWithGoogle_shouldReturnUserData() async throws {
        // given
        let user = AuthDataResultModel(
            id: "testingId123",
            email: "testLogin@gmail.com",
            name: "John Doe",
            photoURL: nil,
            phoneNumber: nil
        )
        
        mockService.mockUser = user
        let mockGoogleHelper = MockGoogleSignInHelper()
        sut = AuthViewModel(authService: mockService, googleSignInHelper: mockGoogleHelper)
        
        //when
        try await sut.signInWithGoogle()
        
        //then
        XCTAssertEqual(sut.currentUser?.email, "testLogin@gmail.com")
        XCTAssertNil(sut.currentUser?.phoneNumber)
        XCTAssertEqual(sut.authState, .authenticated)
        XCTAssertNil(sut.errorMessage)
        XCTAssertNotNil(sut.currentUser)
        
    }

    func test_authViewModel_whenHelperFails_signInWithGoogle_shouldReturnError() async throws {
        let googleHelper = MockGoogleSignInHelper()
        googleHelper.shouldThrowError = true
        
        sut = AuthViewModel(
            authService: mockService,
            googleSignInHelper: googleHelper
        )
        
        let task = Task {
            try await sut.signInWithGoogle()
        }
        
        await Task.yield()
        XCTAssert(sut.isLoading)
        try await task.value
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertEqual(sut.errorMessage, "Google Sign-In gagal.")
        XCTAssertNil(sut.currentUser, "Current user should be nil when Google sign in failed because of error")
        
    }
}
