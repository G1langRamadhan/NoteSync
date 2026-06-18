//
//  NoteViewModelTest.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 16/05/26.
//

import XCTest
@testable import NoteSyncApp

@MainActor
class NoteListViewModelTest: XCTestCase {
    var sut: NoteListViewModel!
    var mockNoteListViewModelTest: MockNoteServiceProtocol!
    
    override func setUp() {
        super.setUp()
        mockNoteListViewModelTest = MockNoteServiceProtocol()
        sut = NoteListViewModel(userId: "testUserId", noteProtocol: mockNoteListViewModelTest)
    }
    
    override func tearDown() {
        sut = nil
        mockNoteListViewModelTest = nil
        super.tearDown()
    }
}
