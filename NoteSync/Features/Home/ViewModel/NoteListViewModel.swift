//
//  NoteListViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import Foundation
import SwiftUI
import Combine

class NoteListViewModel: ObservableObject {

    @Published var searchNote: String = ""
    @Published var isLoading: Bool = false
    @Published var isInitialLoading: Bool = true
    @Published var notes: [NoteModel] = []
    @Published var errorMessage: String?
    @Published var sharedNotes: [NoteModel] = []
    @Published var myNotes: [NoteModel] = []
    
    var filterNoteWithSearch: [NoteModel] {
        guard !searchNote.isEmpty else {
            return notes
        }
        return notes.filter { note in
            note.title.lowercased().contains(searchNote.lowercased())
            || note.body.lowercased().contains(searchNote.lowercased())
        }
    }

    private var noteServiceProtocol: NoteServiceProtocol
    var userId: String
    private var didLoadMyNotes = false
    private var didLoadSharedNotes = false
    
    init(userId: String, noteProtocol: NoteServiceProtocol = FireStoreNoteService()) {
        self.noteServiceProtocol = noteProtocol
        self.userId = userId
        observer()
    }
    
    func deleteNote(noteId: NoteModel) async throws {
        do {
            try await noteServiceProtocol.deleteNote(noteId: noteId.id, userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func observer() {
        noteServiceProtocol.observer(userId: userId) { [weak self] notes in
            self?.didLoadMyNotes = true
            self?.myNotes = notes
            self?.combineAndSortNotes()
            self?.updateLoadingState()
        }
        
        noteServiceProtocol.observeSharedNote(userId: userId) { [weak self] notes in
            self?.didLoadSharedNotes = true
            self?.sharedNotes = notes
            self?.combineAndSortNotes()
            self?.updateLoadingState()
        }
    }
    
    func combineAndSortNotes() {
        var allNotes = myNotes + sharedNotes
        
        allNotes.sort { $0.lastUpdateLocal > $1.lastUpdateLocal }
        notes = allNotes
    }
    
    private func updateLoadingState() {
        isInitialLoading = !(didLoadMyNotes && didLoadSharedNotes)
    }
    
    deinit {
        noteServiceProtocol.removeListener()
    }
}
