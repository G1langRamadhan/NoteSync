//
//  ObserveAuthStateTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import XCTest
@testable import NoteSyncApp

extension AuthViewModelTest {
    func test_authViewModel__whenObserveAuthState_withUser_shouldBeAuthenticated() async {
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
        await Task.yield()
        
        // Then
        XCTAssertEqual(sut.authState, .authenticated)
        XCTAssertNotNil(sut.currentUser)
    }
    
    func test_authViewModel__whenObserveAuthState_withNoUser_shouldBeUnAuthenticated() async {
        // Given
        mockService.observedUser = nil
        
        sut = AuthViewModel(authService: mockService)
        await Task.yield()
        
        // Then
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertNil(sut.currentUser)
    }
}
