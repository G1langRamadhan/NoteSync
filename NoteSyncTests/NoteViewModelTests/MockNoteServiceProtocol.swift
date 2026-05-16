//
//  MockNoteServiceProtocol.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 16/05/26.
//

import XCTest
@testable import NoteSync

class MockNoteServiceProtocol: NoteServiceProtocol {
    
    var mockNotes: [NoteModel]? = nil
    
    // Update & Create note
    var createNoteError: Error? = nil
    var updateNoteError: Error? = nil
    var createdNoteCallCount: Int = 0
    var updatedNoteCallCount: Int = 0
    var lastCreatedNote: NoteModel?
    var lastUpdatedNote: NoteModel?
    var lastCreatedUserId: String?
    var lastUpdatedUserId: String?
    
    // Delete Note
    var deleteNoteError: Error? = nil
    var deletedNoteCallCount: Int = 0
    var deletedNoteId: String?
    
    // Observer Note
    var observerCallCount: Int = 0
    var isObserverCalled: Bool = false
    var isObserveSharedNoteCalled : Bool = false
    var observerOnChange: (([NoteModel]) -> Void)?
    var sharedNoteOnChange: (([NoteModel]) -> Void)?
    
    // Remove Listener
    var removeListenerCallCount: Int = 0
    var isRemoveListenerCalled: Bool = false
    
    
    func createNote(_ noteModel: NoteModel, _ userId: String) async throws {
        try await Task.sleep(for: .milliseconds(100))
        createdNoteCallCount += 1
        lastCreatedNote = noteModel
        lastCreatedUserId = userId
        
        if let error = createNoteError {
            throw error
        }
    }
    
    func updateNote(_ noteModel:NoteModel, _ userId: String) async throws {
        try await Task.sleep(for: .milliseconds(100))
        updatedNoteCallCount += 1
        lastUpdatedNote = noteModel
        lastCreatedUserId = userId
        
        if let error = updateNoteError {
            throw error
        }
    }
    
    func deleteNote(noteId: String, userId: String) async throws {
        deletedNoteCallCount += 1
        deletedNoteId = noteId
        
        if let error = deleteNoteError {
            throw error
        }
    }
    
    func observer(userId: String, onChange: @escaping ([NoteModel]) -> Void) {
        observerCallCount += 1
        isObserverCalled = true
        observerOnChange = onChange
    }
    
    func observeSharedNote(userId: String, onChange: @escaping ([NoteModel]) -> Void) {
        observerCallCount += 1
        isObserveSharedNoteCalled = true
        sharedNoteOnChange = onChange
    }
    
    func removeListener() {
        removeListenerCallCount += 1
        isRemoveListenerCalled = true
    }
}
