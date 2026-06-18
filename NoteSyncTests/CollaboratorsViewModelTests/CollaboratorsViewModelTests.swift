//
//  CollaboratorsViewModelTests.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 11/06/26.
//

import XCTest
@testable import NoteSyncApp

// Belum ada test untuk observer, fetch owner, update role collaborator, delete collaborator, dan deinit removeListener.

class CollaboratorServiceMock: CollaboratorProtocol {
    var authDataResult: Result<AuthDataResultModel, Error> = .success(
        AuthDataResultModel(
            id: "mock-id",
            email: "gramadhan@gmail.com",
            name: "kai",
            photoURL: nil,
            phoneNumber: nil
        )
    )
    
    var collaboratorsResult: Result<[CollaboratorModel], Error> = .success(
        [
            CollaboratorModel(name: "Gilang", role: .editor),
            CollaboratorModel(name: "Keinsten", role: .viewer),
            CollaboratorModel(name: "Kai", role: .viewer)
        ]
    )
    
    var lastUpdatedCollaborator: CollaboratorModel?
    var lastDeletedCollaboratorId: String?
    var observeOnChange: (([CollaboratorModel]) -> Void)?
    
    var updateError: Error? = nil
    var deleteError: Error? = nil
    
    var fetchOwnerCallCount: Int = 0
    var updateCollaboratorCallCount: Int = 0
    var deleteCollaboratorCallCount: Int = 0
    var observeCollaboratorCallCount: Int = 0
    var removeListenerCallCount: Int = 0
    
    func fetchCollaborators(userId: String, noteId: String) async throws -> [CollaboratorModel] {
        return []
    }
    
    func fetchOwnerNote(ownerId: String) async throws -> AuthDataResultModel {
        fetchOwnerCallCount += 1
        return try authDataResult.get()
    }
    
    func updateCollaborators(ownerId: String, noteId: String, collaborator: CollaboratorModel) async throws {
        
    }
    
    func deleteCollaborators(ownerId: String, noteId: String, collaboratorId: String) async throws {
        
    }
    
    func observeCollaborators(ownerId: String, noteId: String, onChange: @escaping ([CollaboratorModel]) -> Void) {
        
    }
    
    func removeListener() {
        
    }
}

// test_[unitOfWork]_[condition]_[expectedBehavior]

@MainActor
final class CollaboratorsViewModelTests: XCTestCase {
    var collaboratorProtocol: CollaboratorServiceMock!
    var sut: CollaboratorsViewModel!
    
    
    override func setUp() async throws {
        try await super.setUp()
        collaboratorProtocol = CollaboratorServiceMock()
    }
    
    // bikin fungsi untuk buat setup sut
    
    override func tearDown() {
        sut = nil
        collaboratorProtocol = nil
        super.tearDown()
    }
    
    func makeSUT() -> CollaboratorsViewModel {
        let note = NoteModel(
            title: "Testing note",
            body: "This is a testing note fore dummy data",
            sharedWith: [
                "kaiId-0989",
                "rai-id-0889"
            ],
            ownerId: "owner-id-0989"
        )
        return CollaboratorsViewModel(
            note: note,
            userId: "owner-id-0989",
            collaboratorProtocol: collaboratorProtocol
        )
    }
    
    
    // Test
    func test_fetchOwnerNote_whenFoundOwnerNote_ShouldReturnOwnerNote() async throws {
        // Given
        sut = makeSUT()
        
        // When
        try await sut.fetchOwnerNote()
        
        // Then
        XCTAssertNotNil(sut.ownerNote)
        XCTAssertEqual(collaboratorProtocol.fetchOwnerCallCount, 1)
        XCTAssertEqual(sut.ownerNote?.email, "gramadhan@gmail.com")
    }
    
    func test_fetchOwnerNote_whenNotFound_ShouldReturnError() async throws {
        // Given
        sut = makeSUT()
        collaboratorProtocol.authDataResult = .failure(URLError(.badURL))
        
        // When
        try await sut.fetchOwnerNote()
        
        // Then
        XCTAssertNil(sut.ownerNote)
        XCTAssertEqual(collaboratorProtocol.fetchOwnerCallCount, 1)
    }
}
