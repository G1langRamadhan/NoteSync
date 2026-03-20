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
    
    init(title: String, body: String) {
        self.id = UUID().uuidString
        self.title = title
        self.body = body
        self.dateCreated = Date()
        self.lastUpdateLocal = Date()
    }
    
    init(from document: NoteDocument) {
        self.id = document.id ?? UUID().uuidString
        self.title = document.title
        self.body = document.body
        self.dateCreated = document.dateCreated.dateValue()
        self.lastUpdateLocal = document.lastUpdateLocal.dateValue()
    }
}


struct NoteDocument: Codable {
    // ini digunakan untuk mengambil documentId pada firebase secara otomatis.
    // Optional karena saat pertama dibuat belum punya ID dari server
    @DocumentID var id: String?
    var title: String
    var body: String
    var ownerId: String
    
    // Timestamp → tipe Firestore, bisa handle timezone server
    var dateCreated: Timestamp
    var lastUpdateLocal: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case ownerId
        case dateCreated
        case lastUpdateLocal
    }
}

struct Collaborators: Codable {
    var id: String
    var name: String?
    var email: String?
    var photoURL: String?
    
    init(user: AuthDataResultModel) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.photoURL = user.photoURL
    }
}
