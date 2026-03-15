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
    @Published var searchSuggestion: [String] = [
        "SwiftUI",
        "Meeting",
        "Project",
        "Ideas",
        "Daily Journal",
        "Workout",
        "Travel"
    ]
    let dummyNotes: [NoteCard] = [
        NoteCard(
            title: "Morning Reflection",
            noteDescription: "Write down three things you are grateful for today and what you want to accomplish.",
            tag: ["Personal", "Reflection"]
        ),
        
        NoteCard(
            title: "SwiftUI Learning",
            noteDescription: "Study about property wrappers, state management, and how data flows in SwiftUI.",
            tag: ["Coding", "SwiftUI", "Learning"]
        ),
        
        NoteCard(
            title: "Weekend Plan",
            noteDescription: "Plan activities for the weekend such as exercising, reading a book, and preparing for next week.",
            tag: ["Lifestyle", "Planning"]
        )
    ]
    
    var filterNoteWithSearch: [NoteCard] {
        guard !searchNote.isEmpty else {
            return dummyNotes
        }
        
        return dummyNotes.filter { note in
            note.title.lowercased().contains(searchNote.lowercased())
            || note.noteDescription.lowercased().contains(searchNote.lowercased())
            || note.tag.contains(where: { $0.lowercased().contains(searchNote.lowercased()) })
        }
    }
}
