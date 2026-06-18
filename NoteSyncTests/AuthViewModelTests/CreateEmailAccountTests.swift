//
//  CreateEmailAccountTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import XCTest
@testable import NoteSyncApp

extension AuthViewModelTest {
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
        let task = Task {
            try await sut.createEmailAccount()
        }
        
        // then
        await Task.yield() // beri waktu async task mulai
        XCTAssert(sut.isLoading)
        try await task.value // menunggu hasil dari task(create email account selesai) selesai
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.authState, .authenticated)
        XCTAssertEqual(sut.currentUser?.id, "testingId123")
        XCTAssertEqual(sut.currentUser?.email, "testaccount@gmail.com")
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_authViewModel_whenCreateUserSucceeds_createUser_shoulClearedFields() async throws {
        // given
        sut.email = "test@gmail.com"
        sut.fullName = "John Doe"
        sut.password = "123456"
        sut.passwordConfirmation = "123456"
        
        let user = AuthDataResultModel(
            id: "testingId123",
            email: "testaccount@gmail.com",
            name: "John Doe",
            photoURL: nil,
            phoneNumber: nil
        )
        mockService.mockUser = user
        
        // when
        try await sut.createEmailAccount()
        
        // then
        XCTAssertEqual(sut.email, "")
        XCTAssertEqual(sut.password, "")
        XCTAssertEqual(sut.fullName, "")
        XCTAssertEqual(sut.passwordConfirmation, "")
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
}
