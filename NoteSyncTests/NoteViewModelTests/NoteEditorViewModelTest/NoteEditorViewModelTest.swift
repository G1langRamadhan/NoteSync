//
//  NoteEditorViewModelTest.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 16/05/26.
//

import XCTest
import SwiftUI
@testable import NoteSyncApp

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
        let notemodel = NoteModel(
            title: "just testing", body: "just for teting body",
            sharedWith: [
            "testingUser1234",
            "anotherUserid"
            ],
            ownerId: "testingUser1234"
        )
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
        XCTAssertEqual(sut.userId, "testingUser1234")
        XCTAssertEqual(sut.note.title, "just testing")
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockNoteListViewModelTest.updatedNoteCallCount, 1)
        XCTAssertEqual(mockNoteListViewModelTest.lastUpdatedUserId, "testingUser1234")
        XCTAssertEqual(mockNoteListViewModelTest.lastUpdatedNote?.id, sut.note.id)
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
    
    func test_noteEditorViewModel_updateSharedNoteSuccesfully_updateSharedNote_shouldBeCalled() async throws {
        // given
        let sharedNote = NoteModel(title: "Shared note with kai", body: "This is a shared note from kai and can be access by kui", sharedWith: ["invitedUser"], ownerId: "otherUserId")
        sut = NoteEditorViewModel(
            notes: sharedNote,
            userId: "invitedUser",
            noteServiceProtocol: mockNoteListViewModelTest
        )
        
        // when
        try await sut.saveNote()
        
        // then
        XCTAssertEqual(sut.syncStatus, .synced)
        XCTAssertEqual(mockNoteListViewModelTest.lastUpdateSharedId, sut.note.id)
        XCTAssertEqual(mockNoteListViewModelTest.updatedSharedNoteCallCount, 1)
        XCTAssert(sut.note.sharedWith.contains(where: { $0 == sut.userId}))
    }
    
    func test_noteEditorViewModel_updateSharedNoteFail_updateSharedNote_shouldBeCalled() async throws {
        // given
        mockNoteListViewModelTest.updateSharedNoteError = NSError(
            domain: "test",
            code: 500,
            userInfo: nil
        )
        let sharedNote = NoteModel(title: "Shared note with kai", body: "This is a shared note from kai and can be access by kui", sharedWith: ["invitedUser"], ownerId: "otherUserId")
        sut = NoteEditorViewModel(
            notes: sharedNote,
            userId: "invitedUser",
            noteServiceProtocol: mockNoteListViewModelTest
        )
        
        // when
        try await sut.saveNote()
        
        // then
        XCTAssertEqual(sut.syncStatus, .error)
        XCTAssertEqual(sut.syncStatusColor, .red)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(mockNoteListViewModelTest.updatedSharedNoteCallCount, 1)
        
    }
    
    func test_noteEditorViewModel_saveNewNoteSuccesfully_saveNote_shouldBeCalled() async throws {
        let noteModel = NoteModel(title: "", body: "body just testing", ownerId: "testingUserId")
        sut = NoteEditorViewModel(notes: noteModel, userId: "testingUserId", noteServiceProtocol: mockNoteListViewModelTest)
        
        try await sut.saveNote()
        
        XCTAssertEqual(sut.syncStatus, .synced)
        XCTAssertEqual(sut.userId, "testingUserId")
        XCTAssertEqual(sut.syncStatusColor, .green)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockNoteListViewModelTest.createdNoteCallCount, 1)
    }
    
    func test_noteEditorViewModel_syncStatusChange_syncStatus_shouldChangeBaseOndSyncStatus() async throws {
        // Given
        let newNote = NoteModel(title: "", body: "This is new note", sharedWith: [""], ownerId: "userId")
        sut = NoteEditorViewModel(
            notes: newNote,
            userId: "userId",
            noteServiceProtocol: mockNoteListViewModelTest
        )
        
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
        XCTAssertEqual(sut.note.sharedWith, [""])
        XCTAssertEqual(mockNoteListViewModelTest.createdNoteCallCount, 1)
    }
    
}
