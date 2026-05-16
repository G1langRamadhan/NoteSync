//
//  DeinitTest.swift
//  NoteSyncTests
//
//  Created by Gilang Ramadhan on 16/05/26.
//

import XCTest
@testable import NoteSync

extension NoteListViewModelTest {
    func test_noteListViewModel_deinitSuccess_deinit_shouldCallDeinit() {
        sut = nil
        XCTAssertEqual(mockNoteListViewModelTest.removeListenerCallCount, 1)
    }
}
