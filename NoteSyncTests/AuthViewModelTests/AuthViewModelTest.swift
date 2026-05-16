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
final class AuthViewModelTest: XCTestCase {
    var sut: AuthViewModel!
    var mockService : MockAuthService!
    
    override func setUp()  {
        super.setUp()
        mockService = MockAuthService()
        mockService.observedUser = nil
        sut = AuthViewModel(authService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func test_authViewModel_whenCreateUserSucceeds_createUser_shouldReturnUserData() async throws {
        // Given
        let user = AuthDataResultModel(
            id: "testingId123",
            email: "testaccount@gmail.com",
            name: "John Doe",
            photoURL: nil,
            phoneNumber: nil
        )
        
        mockService.mockUser = user
        
        // When
        try await sut.createEmailAccount()
        
        // then
        XCTAssertEqual(sut.authState, .authenticated)
        XCTAssertEqual(sut.currentUser?.id, "testingId123")
        XCTAssertEqual(sut.currentUser?.email, "testaccount@gmail.com")
        XCTAssert(!sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_authViewModel_whenCreatingUsersFailsBecauseNetworkError_createUser_shouldReturnError() async throws {
        mockService.mockError = .networkError
        mockService.shouldThrowError = true
        
        try await sut.createEmailAccount()
        
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertEqual(sut.errorMessage, "Tidak ada koneksi internet.")
        XCTAssertNil(sut.currentUser)
    }
    
    func test_authViewModel_whenCreatingUserWithExistingEmail_createUser_shouldReturnError() async throws {
        mockService.mockError = .emailAlreadyInUse
        mockService.shouldThrowError = true
        
        try await sut.createEmailAccount()
        
        XCTAssertEqual(mockService.mockError, .emailAlreadyInUse)
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertEqual(sut.errorMessage, "Email ini sudah terdaftar.")
        XCTAssertNil(sut.currentUser)
        XCTAssertNotNil(sut.errorMessage)
    }
    
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
    
    
    func test_authViewModel_whenSignout_logOut_shouldReturnLogout() throws {
        try sut.signOut()
        
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertNil(sut.currentUser)
    }
    
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
        
        //when
        // buat protocol untuk signin with apple
        try await sut.sigInWithApple()
        
        //then
        XCTAssertEqual(sut.currentUser?.email, "testingId123")
        XCTAssertNil(sut.currentUser?.phoneNumber)
        XCTAssertEqual(sut.authState, .authenticated)
        XCTAssertNil(sut.errorMessage)
        XCTAssertNotNil(sut.currentUser)
        
    }
}
