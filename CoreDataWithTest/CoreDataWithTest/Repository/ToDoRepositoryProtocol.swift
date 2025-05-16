//
//  ToDoRepositoryProtocol.swift
//  CoreDataWithTest
//
//  Created by Habibur Rahman on 15/5/25.
//

import Foundation

protocol ToDoRepositoryProtocol {
    func insert(toDos: [TodoModel]) async throws -> Bool
    func retrieve() async throws -> [TodoModel]
    func update(updatedData : TodoModel) async throws -> TodoModel
    func delete(id: String) async throws -> Bool
}
