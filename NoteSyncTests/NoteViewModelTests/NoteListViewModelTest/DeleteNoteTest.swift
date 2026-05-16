//
//  CreateNoteTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 16/05/26.
//

import XCTest
@testable import NoteSync

extension NoteViewModelTest {
    func test_noteListViewModel_successDeleteNote_deleteNote_shouldNoError() async throws {
        // Given
        let noteModel = NoteModel(title: "TestingNoteModel", body: "The purpose only focus on note model")
        sut = NoteListViewModel(userId: noteModel.id, noteProtocol: mockNoteListViewModelTest)
        
        // when
        try await sut.deleteNote(noteId: noteModel)
        
        // then
        XCTAssertNil(mockNoteListViewModelTest.deleteNoteError)
        XCTAssertEqual(mockNoteListViewModelTest.deletedNoteId, sut.userId)
        XCTAssertEqual(mockNoteListViewModelTest.deletedNoteCallCount, 1)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_noteListViewModel_failDeleteNote_deleteNote_shouldError() async throws {
        // given
        let noteModel = NoteModel(title: "TestingNoteModel", body: "The purpose only focus on note model")
        mockNoteListViewModelTest.deleteNoteError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: nil
        )
        
        // when
        try await sut.deleteNote(noteId: noteModel)
        
        
        // then
        XCTAssertNotNil(mockNoteListViewModelTest.deleteNoteError)
        XCTAssertEqual(mockNoteListViewModelTest.deletedNoteCallCount, 1)
        XCTAssertNotEqual(mockNoteListViewModelTest.deletedNoteId, sut.userId)
        XCTAssertNotNil(sut.errorMessage)
    }
}
