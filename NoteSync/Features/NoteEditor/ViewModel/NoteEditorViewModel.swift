//
//  NoteEditorViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import Foundation
import Combine
import SwiftUI

class NoteEditorViewModel: ObservableObject {
    enum SyncState {
        case synced
        case syncing
        case error
        case offline
    }
    
    @Published var note: NoteModel
    @Published var syncStatus: SyncState = .synced
    @Published var errorMessage: String?
    
    var userId: String
    private var isNewNote: Bool
    private var isSaving = false
    private var cancellables = Set<AnyCancellable>()
    
    private var noteServiceProtocol: NoteServiceProtocol
    
    init(notes: NoteModel, userId: String, noteServiceProtocol: NoteServiceProtocol = FireStoreNoteService()) {
        self.note = notes
        self.userId = userId
        self.isNewNote = notes.title.isEmpty
        self.noteServiceProtocol = noteServiceProtocol
        autoSave()
    }
    
    private var hasMeaningfulContent: Bool {
        let title = note.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = note.body.trimmingCharacters(in: .whitespacesAndNewlines)
        return !title.isEmpty || !body.isEmpty
    }

    var formattedDate: String {
        // Format: "15 Maret 2026  09:41"  — persis seperti Notes app
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy  HH:mm"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: Date())
    }
    
    
    var syncStatusColor: Color {
        switch syncStatus {
        case .syncing:
            return .blue
        case .error:
            return .red
        case .synced:
            return .green
        case .offline:
            return .purple
        }
    }
    
    func autoSave() {
        Publishers.CombineLatest($note.map(\.title), $note.map(\.body))
            .removeDuplicates { lhs, rhs in
                lhs.0 == rhs.0 && lhs.1 == rhs.1
            }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .dropFirst()
            .sink { [weak self] _, _ in
                guard let self, !self.isSaving else { return }
                Task { try await self.saveNote() }
            }
            .store(in: &cancellables)
    }
    
    func saveNote() async throws {
        guard !isSaving else { return }
        isSaving = true
        defer { isSaving = false }
        
        if isNewNote && !hasMeaningfulContent {
            syncStatus = .synced
            return
        }
        
        note.lastUpdateLocal = Date()
        syncStatus = .syncing
        do {
            if note.ownerId != userId {
                try await noteServiceProtocol.updateNoteSharedNote(note)
            } else {
                guard isNewNote else {
                    try await noteServiceProtocol.updateNote(note, userId)
                    syncStatus = .synced
                    return
                }
                
                try await noteServiceProtocol.createNote(note, userId)
                isNewNote = false
            }
            syncStatus = .synced
        } catch {
            syncStatus = .error
            errorMessage = error.localizedDescription
        }
    }
}
