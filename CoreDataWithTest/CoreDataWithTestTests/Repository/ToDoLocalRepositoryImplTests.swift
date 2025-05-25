//
//  ToDoLocalRepositoryImplTests.swift
//  CoreDataWithTestTests
//
//  Created by Habibur Rahman on 15/5/25.
//

import XCTest
@testable import CoreDataWithTest


/// Unit tests for `ToDoLocalRepositoryImpl`.
/// Verifies correct behavior of insert, retrieve, update, and delete operations
/// using a mocked local data store.
final class ToDoLocalRepositoryImplTests: XCTestCase {
    
    var store: MockToDoLocalDataStore!
    var sut: ToDoLocalRepositoryImpl!

    /// Set up test environment before each test case.
    override func setUp() {
        super.setUp()
        store = try? MockToDoLocalDataStore()
        sut = ToDoLocalRepositoryImpl(store: store)
    }

    /// Clean up after each test case.
    override func tearDown() {
        store = nil
        sut = nil
        super.tearDown()
    }

    /// Tests successful insert operation returns `true`.
    func testInsert_success_returnsTrue() async throws {
        let dummy = ToDoTestHelper.makeDummyTodoCoreDataModel()
        store.inectedRetrieveDatas = [dummy]
        let result = try await sut.insert(toDos: [dummy.toTodoModelData()])
        XCTAssertTrue(result)
    }

    /// Tests insert operation throws an error on failure.
    func testInsert_failure_throwsError() async {
        let dummy = ToDoTestHelper.makeDummyTodoCoreDataModel().toTodoModelData()
        store.shouldThrowError = true
        do {
            _ = try await sut.insert(toDos: [dummy])
            XCTFail("Expected insert to throw")
        } catch {
            XCTAssertEqual((error as NSError).domain, "InsertError")
        }
    }

    /// Tests successful data retrieval returns expected result.
    func testRetrieve_success_returnsData() async throws {
        let dummy = ToDoTestHelper.makeDummyTodoCoreDataModel()
        store.inectedRetrieveDatas = [dummy]
        let result = try await sut.retrieve()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, dummy.id)
    }

    /// Tests retrieve operation throws an error on failure.
    func testRetrieve_failure_throwsError() async {
        store.shouldThrowError = true
        do {
            _ = try await sut.retrieve()
            XCTFail("Expected retrieve to throw")
        } catch {
            XCTAssertEqual((error as NSError).domain, "RetrieveError")
        }
    }

    /// Tests successful update returns the updated model.
    func testUpdate_success_returnsUpdatedData() async throws {
        let dummy = ToDoTestHelper.makeDummyTodoCoreDataModel()
        store.injectedUpdateModel = dummy
        let result = try await sut.update(updatedData: dummy.toTodoModelData())
        XCTAssertEqual(result.id, dummy.id)
        XCTAssertEqual(store.injectedUpdateModel?.note, dummy.note)
    }

    /// Tests update operation throws an error on failure.
    func testUpdate_failure_throwsError() async {
        store.shouldThrowError = true
        let dummy = ToDoTestHelper.makeDummyTodoCoreDataModel()
        do {
            _ = try await sut.update(updatedData: dummy.toTodoModelData())
            XCTFail("Expected update to throw")
        } catch {
            XCTAssertEqual((error as NSError).domain, "UpdateError")
        }
    }

    /// Tests successful delete operation returns `true`.
    func testDelete_success_returnsTrue() async throws {
        let dummy = ToDoTestHelper.makeDummyTodoCoreDataModel()
        let result = try await sut.delete(id: dummy.id)
        XCTAssertTrue(result)
    }

    /// Tests delete operation throws an error on failure.
    func testDelete_failure_throwsError() async {
        store.shouldThrowError = true
        let dummy = ToDoTestHelper.makeDummyTodoCoreDataModel()
        do {
            _ = try await sut.delete(id: dummy.id)
            XCTFail("Expected delete to throw")
        } catch {
            XCTAssertEqual((error as NSError).domain, "DeleteError")
        }
    }
}
