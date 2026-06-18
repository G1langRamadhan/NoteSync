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
    
    init(
        userId: String,
        noteProtocol: NoteServiceProtocol = FireStoreNoteService(),
        
    ) {
        self.noteServiceProtocol = noteProtocol
        self.userId = userId
        observer()
    }
    
    func deleteNote(noteId: NoteModel) async {
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
    
    func updateNote(note: NoteModel) async {
        do {
            var updatePinnedStatus = note
            updatePinnedStatus.pinned = note.pinned ? false : true
            try await noteServiceProtocol.updateNote(updatePinnedStatus, userId)
        } catch {
            errorMessage = error.localizedDescription
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

extension NoteListViewModel {

    // MARK: - Loading State

    static var previewLoading: NoteListViewModel {
        let vm = NoteListViewModel(
            userId: "preview-user",
            noteProtocol: MockNoteService()
        )

        vm.isInitialLoading = true

        return vm
    }

    // MARK: - Empty State

    static var previewEmpty: NoteListViewModel {
        let vm = NoteListViewModel(
            userId: "preview-user",
            noteProtocol: MockNoteService()
        )

        vm.isInitialLoading = false
        vm.notes = []

        return vm
    }

    // MARK: - Filled State

    static var previewFilled: NoteListViewModel {
        let vm = NoteListViewModel(
            userId: "preview-user",
            noteProtocol: MockNoteService()
        )

        vm.isInitialLoading = false

        vm.myNotes = [
            NoteModel(
                title: "SwiftUI Architecture",
                body: "Belajar MVVM, dependency injection, dan navigation.",
                ownerId: "preview-user"
            ),
            NoteModel(
                title: "Firebase Setup",
                body: "Konfigurasi Authentication dan Firestore.",
                ownerId: "preview-user"
            )
        ]

        vm.sharedNotes = [
            NoteModel(
                title: "Meeting Notes",
                body: "Diskusi fitur collaborator dan sharing note.",
                ownerId: "john"
            ),
            NoteModel(
                title: "Product Roadmap",
                body: "Target release Notely beta bulan depan.",
                ownerId: "alex"
            )
        ]
        vm.combineAndSortNotes()
        return vm
    }
}

class MockNoteService: NoteServiceProtocol {
    func createNote(_ noteModel: NoteModel, _ userId: String) async throws {
        
    }
    
    func updateNote(_ noteModel: NoteModel, _ userId: String) async throws {
        
    }
    
    func updateNoteSharedNote(_ noteModel: NoteModel) async throws {
        
    }
    
    func deleteNote(noteId: String, userId: String) async throws {
        
    }
    
    func observer(userId: String, onChange: @escaping ([NoteModel]) -> Void) {
        
    }
    
    func observeSharedNote(userId: String, onChange: @escaping ([NoteModel]) -> Void) {
        
    }
    
    func removeListener() {
        
    }
}
