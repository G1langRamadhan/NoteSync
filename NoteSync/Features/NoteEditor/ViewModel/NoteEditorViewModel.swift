//
//  NoteEditorViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import Foundation
import Combine
import SwiftUI

enum SyncState {
    case synced
    case syncing
    case error
    case offline
}

class NoteEditorViewModel: ObservableObject {
    
    @Published var note: NoteModel
    @Published var syncStatus: SyncState = .synced
    @Published var errorMessage: String?
    
    var userId: String
    private var isNewNote: Bool
    private var cancellables = Set<AnyCancellable>()
    
    private var noteServiceProtocol: NoteServiceProtocol
    
    init(notes: NoteModel, userId: String, noteServiceProtocol: NoteServiceProtocol = FireStoreNoteService()) {
        self.note = notes
        self.userId = userId
        self.isNewNote = notes.title.isEmpty
        self.noteServiceProtocol = noteServiceProtocol
        autoSave()
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
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .dropFirst()
            .sink { [weak self] _, _ in
                guard let self else {return}
                Task { try await self.saveNote() }
            }
            .store(in: &cancellables)
    }
    
    func saveNote() async throws {
        syncStatus = .syncing
        do {
            if isNewNote {
                try await noteServiceProtocol.createNote(note, userId)
            } else {
                try await noteServiceProtocol.updateNote(note, userId)
            }
            syncStatus = .synced
        } catch {
            syncStatus = .error
            errorMessage = "Gagal menyimpan. Perubahan tersimpan lokal."
        }
    }
}
