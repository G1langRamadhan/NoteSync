//
//  NoteEditorViewModelTest.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 16/05/26.
//

import XCTest
import SwiftUI
@testable import NoteSync

@MainActor
final class NoteEditorViewModelTest: XCTestCase {
    var sut: NoteEditorViewModel!
    var mockNoteListViewModelTest: MockNoteServiceProtocol!
    
    override func setUp() {
        super.setUp()
        mockNoteListViewModelTest = MockNoteServiceProtocol()
    }
    
    override func tearDown() {
        sut = nil
        mockNoteListViewModelTest = nil
        super.tearDown()
    }
    
    func makeSUT() -> NoteEditorViewModel {
        let notemodel = NoteModel(title: "just testing", body: "body just testing")
        return NoteEditorViewModel(
            notes: notemodel,
            userId: "testingUser1234",
            noteServiceProtocol: mockNoteListViewModelTest
        )
    }
    
    
    func test_noteEditorViewModel_updateNoteSuccesfully_saveNote_shouldBeCalled() async throws {
        // Given
        sut = makeSUT()
        
        // When
        try await sut.saveNote()
        
        // Then
        XCTAssertEqual(sut.syncStatus, .synced)
        XCTAssertEqual(sut.userId, sut.note.id)
        XCTAssertEqual(sut.note.title, "just testing")
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockNoteListViewModelTest.updatedNoteCallCount, 1)
    }
    
    func test_noteEditorViewModel_updateNoteFailed_saveNote_shouldBeCalled() async throws {
        // Given
        mockNoteListViewModelTest.updateNoteError = NSError(
            domain: "test",
            code: 500,
            userInfo: nil
        )
        
        sut = makeSUT()
        
        // When
        try await sut.saveNote()
        
        // Then
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.syncStatus, .error)
        XCTAssertEqual(sut.syncStatusColor, .red)
        XCTAssertEqual(mockNoteListViewModelTest.updatedNoteCallCount, 1)
    }
    
    func test_noteEditorViewModel_saveNewNoteSuccesfully_saveNote_shouldBeCalled() async throws {
        let noteModel = NoteModel(title: "", body: "body just testing")
        sut = NoteEditorViewModel(notes: noteModel, userId: "testing", noteServiceProtocol: mockNoteListViewModelTest)
        
        try await sut.saveNote()
        
        XCTAssertEqual(sut.syncStatus, .synced)
        XCTAssertEqual(sut.userId, "testing")
        XCTAssertEqual(sut.syncStatusColor, .green)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockNoteListViewModelTest.createdNoteCallCount, 1)
    }
    
    func test_noteEditorViewModel_syncStatusChange_syncStatus_shouldChangeBaseOndSyncStatus() async throws {
        // Given
        sut = makeSUT()
        
        // when
        let task = Task {
            try await sut.saveNote()
        }
        
        // then
        await Task.yield()
        XCTAssertEqual(sut.syncStatus, .syncing)
        XCTAssertEqual(sut.syncStatusColor, .blue)
        try await task.value
        XCTAssertEqual(sut.syncStatus, .synced)
        XCTAssertEqual(sut.syncStatusColor, .green)
        XCTAssertEqual(mockNoteListViewModelTest.updatedNoteCallCount, 1)
        
    }
    
}
