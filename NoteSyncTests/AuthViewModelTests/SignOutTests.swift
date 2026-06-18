//
//  SignOutTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 15/05/26.
//

import XCTest
@testable import NoteSyncApp

extension AuthViewModelTest {
    func test_authViewModel_whenSignout_logOut_shouldReturnLogout() throws {
        try sut.signOut()
        
        XCTAssertEqual(sut.authState, .unauthenticated)
        XCTAssertNil(sut.currentUser)
    }
    
    //buat kalau gagal logout
    func test_authViewModel_whenFailedSignout_logOut_shouldReturnError() throws {
        // Given
        mockService.mockError = .unknown("Gagal keluar. Coba lagi.")
        mockService.shouldThrowError = true
        
        // When
        try  sut.signOut()
        
        // Then
        XCTAssertEqual(sut.errorMessage, "Gagal keluar. Coba lagi.")
    }
}
