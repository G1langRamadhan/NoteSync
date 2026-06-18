//
//  SignInWithAppleTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import XCTest
@testable import NoteSyncApp

extension AuthViewModelTest {
    func test_authViewModel_whenSignInWithGoogle_sigInWithApple_shouldReturnUserData() async throws {
        // given
        let user = AuthDataResultModel(
            id: "testingId123",
            email: "testLogin@gmail.com",
            name: "John Doe",
            photoURL: nil,
            phoneNumber: nil
        )
        
        mockService.mockUser = user
        
        sut = AuthViewModel(
            authService: mockService,
            appleSignInHelper: MockAppleSignInHelper()
        )
        
        //when
        try await sut.sigInWithApple()
        
        //then
        XCTAssertEqual(sut.currentUser?.email, "testLogin@gmail.com")
        XCTAssertNil(sut.currentUser?.phoneNumber)
        XCTAssertEqual(sut.authState, .authenticated)
        XCTAssertNil(sut.errorMessage)
        XCTAssertNotNil(sut.currentUser)
    }
    
    // buat test error ketika login with apple
    func test_authViewModel_whenHelperFails_signInWithApple_shouldReturnError() async throws {
        //given
        let appleSignInHelper = MockAppleSignInHelper()
        appleSignInHelper.shouldThrowError = true
        
        sut = AuthViewModel(
            authService: mockService,
            appleSignInHelper: appleSignInHelper
        )
        
        // when
        try await sut.sigInWithApple()
        await Task.yield()
        
        // then
        XCTAssertEqual(appleSignInHelper.helperCallCount, 1, "Helper call count should be 1")
        XCTAssertEqual(sut.errorMessage, "Apple Sign-In gagal")
        XCTAssertNil(sut.currentUser)
        XCTAssertEqual(sut.authState, .unauthenticated)
    }
}
