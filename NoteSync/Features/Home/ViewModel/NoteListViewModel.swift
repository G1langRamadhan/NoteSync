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
    private var userId: String
    
    init(userId: String, noteProtocol: FireStoreNoteService = FireStoreNoteService()) {
        self.noteServiceProtocol = noteProtocol
        self.userId = userId
        observer()
    }
    
    func deleteNote(noteId: NoteModel) async throws {
        do {
            try await noteServiceProtocol.deleteNote(id: noteId.id)
        } catch {
            
        }
    }

    func observer() {
        noteServiceProtocol.observer(userId: userId) { [weak self] notes in
            print("Notes di observer\(notes)")
            self?.notes = notes
        }
    }
    
    deinit {
        noteServiceProtocol.removeListener()
    }
}
