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
    @Published var notes: [NoteModel] = []
    @Published var errorMessage: String?
    
    private var myNotes: [NoteModel] = []
    private var sharedNotes: [NoteModel] = []
    
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
    /*private*/ var userId: String
    
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
            self?.myNotes = notes
            self?.combineAndSortNotes()
        }
        
        noteServiceProtocol.observeSharedNote(userId: userId) { [weak self] notes in
            self?.sharedNotes = notes
            self?.combineAndSortNotes()
        }
    }
    
    func combineAndSortNotes() {
        var allNotes = myNotes + sharedNotes
        
        allNotes.sort { $0.lastUpdateLocal > $1.lastUpdateLocal }
        notes = allNotes
    }
    
    deinit {
        noteServiceProtocol.removeListener()
    }
}
