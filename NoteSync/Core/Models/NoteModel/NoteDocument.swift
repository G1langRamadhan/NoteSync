//
//  NoteModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 18/03/26.
//

import Foundation
import FirebaseFirestore

struct NoteDocument: Codable {
    // ini digunakan untuk mengambil documentId pada firebase secara otomatis.
    // Optional karena saat pertama dibuat belum punya ID dari server
    @DocumentID var id: String?
    var title: String
    var body: String
    var ownerId: String
    var sharedWith: [String]
    
    // Timestamp → tipe Firestore, bisa handle timezone server
    var dateCreated: Timestamp
    var lastUpdateLocal: Timestamp
    var pinned: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case ownerId
        case dateCreated
        case lastUpdateLocal
        case sharedWith
        case pinned
    }
}
