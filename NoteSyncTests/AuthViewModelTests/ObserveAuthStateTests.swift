//
//  ObserveAuthStateTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import XCTest
@testable import NoteSync

extension AuthViewModelTest {
    func test_authViewModel__whenObserveAuthState_withUser_shouldBeAuthenticated() {
        // Given
        let user = AuthDataResultModel(
            id: "testingId123",
            email: "testaccount@gmail.com",
            name: "John Doe",
            photoURL: nil,
            phoneNumber: nil
        )
        
        mockService.observedUser = user
        
        // when
        sut = AuthViewModel(authService: mockService)
        
        // Then
        XCTAssertEqual(sut.authState, .authenticated)
        XCTAssertNotNil(sut.currentUser)
    }
    
    func test_authViewModel__whenObserveAuthState_withNoUser_shouldBeUnAuthenticated() {
        // Given
        mockService.observedUser = nil
        
        sut = AuthViewModel(authService: mockService)
        
        // Then
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertNil(sut.currentUser)
    }
}
