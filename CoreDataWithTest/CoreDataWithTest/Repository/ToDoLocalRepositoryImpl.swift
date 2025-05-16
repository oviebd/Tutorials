//
//  ToDoLocalRepositoryImpl.swift
//  CoreDataWithTest
//
//  Created by Habibur Rahman on 15/5/25.
//

import Foundation

class ToDoLocalRepositoryImpl: ToDoRepositoryProtocol {
    
    private let store: ToDoLocalDataStore

    init(store: ToDoLocalDataStore) {
        self.store = store
    }

    func insert(toDos: [TodoModel]) async throws -> Bool {
        let coreDataModels = toDos.map { $0.toCoreDataModel() }
        return try await store.insert(pdfDatas: coreDataModels)
    }

    func retrieve() async throws -> [TodoModel] {
        let coreDataList = try await store.retrieve()
        return coreDataList.compactMap { $0.toTodoModelData() }
    }

    func update(updatedData : TodoModel) async throws -> TodoModel {
        let updatedCoreData = try await store.update(updatedData: updatedData.toCoreDataModel())
        return updatedCoreData.toTodoModelData()
    }

    func delete(id: String) async throws -> Bool {
        return try await store.delete(id: id)
    }
}
