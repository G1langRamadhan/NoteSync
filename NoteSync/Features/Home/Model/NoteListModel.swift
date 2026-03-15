//
//  NoteListMode.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import Foundation


struct NoteCard: Identifiable {
    let id = UUID()
    let title: String
    let noteDescription: String
    let tag: [String]
}
