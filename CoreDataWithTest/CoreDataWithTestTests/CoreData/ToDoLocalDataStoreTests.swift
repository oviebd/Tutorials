//
//  ToDoLocalDataStoreTests.swift
//  CoreDataWithTestTests
//
//  Created by Habibur Rahman on 15/5/25.
//

import XCTest
import CoreData
@testable import CoreDataWithTest

/// Unit tests for `ToDoLocalDataStore`, which handles CRUD operations for ToDo items using CoreData.
final class ToDoLocalDataStoreTests: XCTestCase {
    var sut: ToDoLocalDataStore! // System under test
    
    /// Set up a fresh in-memory CoreData store before each test
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storeURL = URL(fileURLWithPath: "/dev/null") // In-memory database (doesn't save to disk)
        sut = try ToDoLocalDataStore(storeURL: storeURL)
    }
    
    /// Tear down the store after each test
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    /// Test inserting a ToDo item and then retrieving it.
    /// Expects: Insert returns true, and retrieve returns the inserted item.
    func testInsertAndRetrieveToDo() async throws {
        let todo = ToDoTestHelper.makeDummy(note: "Test Note", isDone: false)
        let success = try await sut.insert(pdfDatas: [todo])
        XCTAssertTrue(success)
        
        let result = try await sut.retrieve()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first, todo)
    }
    
    /// Test updating a ToDo item.
    /// Expects: Update returns the modified item, and the retrieved data matches the update.
    func testUpdateToDo() async throws {
        var todo = ToDoTestHelper.makeDummy(note: "Initial", isDone: false)
        let success = try await sut.insert(pdfDatas: [todo])
        XCTAssertTrue(success)
        
        // Modify the item and update it
        todo.note = "Updated Note"
        todo.isDone = true
        let updated = try await sut.update(updatedData: todo)

        // Check if updated correctly
        XCTAssertEqual(updated, todo)

        // Fetch the item again and validate
        let fetched = try await sut.retrieve().first { $0.id == todo.id }
        XCTAssertEqual(fetched, todo)
    }

    /// Test deleting a ToDo item.
    /// Expects: Deletion is successful and the item is no longer retrieved.
    func testDeleteToDo() async throws {
        let todo = ToDoTestHelper.makeDummy(note: "To be deleted", isDone: false)
        let success = try await sut.insert(pdfDatas: [todo])
        XCTAssertTrue(success)
        
        let deleted = try await sut.delete(pdfKey: todo.id)
        XCTAssertTrue(deleted)

        let result = try await sut.retrieve()
        XCTAssertTrue(result.isEmpty)
    }

    /// Test filtering ToDo items by different criteria (isDone, id, both).
    /// Expects: The correct matching items are returned in each case.
    func testFilterToDos() async throws {
        let todo1 = ToDoTestHelper.makeDummy(id: "1", note: "Note 1", isDone: false)
        let todo2 = ToDoTestHelper.makeDummy(id: "2", note: "Note 2", isDone: true)
        let success = try await sut.insert(pdfDatas: [todo1, todo2])
        XCTAssertTrue(success)

        // Filter items that are done
        let resultsIsDone = try await sut.filter(parameters: ["isDone": true])
        XCTAssertEqual(resultsIsDone.count, 1)
        XCTAssertEqual(resultsIsDone.first?.id, "2")

        // Filter by specific ID
        let resultsById = try await sut.filter(parameters: ["id": "1"])
        XCTAssertEqual(resultsById.count, 1)
        XCTAssertEqual(resultsById.first?.id, "1")

        // Filter by ID and isDone together
        let resultsBoth = try await sut.filter(parameters: ["id": "2", "isDone": true])
        XCTAssertEqual(resultsBoth.count, 1)
        XCTAssertEqual(resultsBoth.first?.id, "2")

        // Filter with mismatching parameters (should return nothing)
        let resultsNone = try await sut.filter(parameters: ["id": "1", "isDone": true])
        XCTAssertEqual(resultsNone.count, 0)
    }

    /// Test updating a non-existent ToDo item.
    /// Expects: The method throws an error.
    func testUpdateWithInvalidIDThrows() async {
        let invalid = ToDoTestHelper.makeDummy(note: "Nothing", isDone: false)
        do {
            _ = try await sut.update(updatedData: invalid)
            XCTFail("Expected update to throw an error, but it didn't.")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    /// Test deleting a ToDo item with a non-existent ID.
    /// Expects: The method throws an error.
    func testDeleteWithInvalidKeyThrows() async {
        do {
            _ = try await sut.delete(pdfKey: "non-existent-id")
            XCTFail("Expected delete to throw an error, but it didn't.")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
