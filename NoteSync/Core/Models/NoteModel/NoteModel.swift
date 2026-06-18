//
//  NoteModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 18/03/26.
//

import Foundation
import FirebaseFirestore

struct NoteModel: Identifiable, Hashable {
    var id: String
    var title: String
    var body: String
    var lastUpdateLocal: Date
    var dateCreated: Date
    var sharedWith: [String]
    var ownerId: String = ""
    var pinned: Bool = false
    
    init(title: String, body: String, ownerId: String) {
        self.id = UUID().uuidString
        self.sharedWith = []
        self.title = title
        self.body = body
        self.dateCreated = Date()
        self.lastUpdateLocal = Date()
        self.ownerId = ownerId
    }
    
    // For unit test only
    init(title: String, body: String, sharedWith: [String], ownerId: String ) {
        self.id = UUID().uuidString
        self.sharedWith = sharedWith
        self.title = title
        self.body = body
        self.dateCreated = Date()
        self.lastUpdateLocal = Date()
        self.ownerId = ownerId
    }
    
    init(from document: NoteDocument) {
        self.id = document.id ?? UUID().uuidString
        self.title = document.title
        self.body = document.body
        self.dateCreated = document.dateCreated.dateValue()
        self.lastUpdateLocal = document.lastUpdateLocal.dateValue()
        self.sharedWith = document.sharedWith
        self.ownerId = document.ownerId
        self.pinned = document.pinned
    }
}
