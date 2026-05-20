//
//  ObserveNoteTest.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 16/05/26.
//

import XCTest
@testable import NoteSync

extension NoteListViewModelTest {
    func test_noteListViewModel_successfullyObserveNote_observer_shouldBeCalled() {
        // When
        mockNoteListViewModelTest.observerCallCount = 0
        sut = NoteListViewModel(userId: "testoViewModel", noteProtocol: mockNoteListViewModelTest)
        
        // Then
        XCTAssertEqual(mockNoteListViewModelTest.observerCallCount, 2)
        XCTAssert(mockNoteListViewModelTest.isObserverCalled)
        XCTAssert(mockNoteListViewModelTest.isObserveSharedNoteCalled)
    }
    
    func test_noteListViewModel_successfullyCombineAndSortnote_observer_shouldBeCombineAndSort() {
        // Given
        let myNote = NoteModel(title: "MyNoteTesting", body: "This is a test for my note")
        let sharedNote = NoteModel(title: "SharedNoteTesting", body: "This is a test for shared note")
        
        // When
        mockNoteListViewModelTest.observerOnChange?([myNote, sharedNote])
        
        
        // Then
        XCTAssertEqual(mockNoteListViewModelTest.observerCallCount, 2)
        XCTAssertEqual(sut.filterNoteWithSearch.count, 2)
        XCTAssertEqual(sut.filterNoteWithSearch.first?.id, sharedNote.id)
    }
    
    func test_noteListViewModel_searchNoteEmpty_observer_shouldReturnAllNotes() {
        let myNote = NoteModel(title: "MyNoteTesting", body: "This is a test for my note")
        let sharedNote = NoteModel(title: "SharedNoteTesting", body: "This is a test for shared note")
        
        mockNoteListViewModelTest.observerOnChange?([myNote, sharedNote])
        
        XCTAssertEqual(sut.filterNoteWithSearch.count, 2)
        XCTAssert(sut.searchNote.isEmpty)
    }
}
