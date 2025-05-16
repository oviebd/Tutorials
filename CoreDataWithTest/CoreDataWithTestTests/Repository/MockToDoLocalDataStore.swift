//
//  MockToDoLocalDataStore.swift
//  CoreDataWithTestTests
//
//  Created by Habibur Rahman on 15/5/25.
//

import Foundation
@testable import CoreDataWithTest

class MockToDoLocalDataStore: ToDoLocalDataStore {
    
    var injectedUpdateModel: ToDoCoreDataModel?
    var inectedRetrieveDatas: [ToDoCoreDataModel] = []
    
    var shouldThrowError = false

    
    override func insert(pdfDatas: [ToDoCoreDataModel]) async throws -> Bool {
        if shouldThrowError { throw NSError(domain: "InsertError", code: -1, userInfo: nil) }
        return true
    }

    
    override func retrieve() async throws -> [ToDoCoreDataModel] {
        if shouldThrowError { throw NSError(domain: "RetrieveError", code: -1, userInfo: nil) }
        return inectedRetrieveDatas
    }
    
    override func update(updatedData: ToDoCoreDataModel) async throws -> ToDoCoreDataModel {
        if shouldThrowError { throw NSError(domain: "UpdateError", code: -1, userInfo: nil) }
        return injectedUpdateModel!
    }
    
    override func delete(id: String) async throws -> Bool {
        if shouldThrowError { throw NSError(domain: "DeleteError", code: -1, userInfo: nil) }
        return true
    }
}
