//
//  ToDoLocalDataStore.swift
//  CoreDataWithTest
//
//  Created by Habibur Rahman on 12/5/25.
//

import CoreData
import Foundation

class ToDoLocalDataStore {
    struct ModelNotFound: Error {
        let modelName: String
    }

    struct DataAlreadyExistError: Error {
        let description: String
    }

    static let modelName = "ToDoDataContainer"
    static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: ToDoLocalDataStore.self))

    private let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init(storeURL: URL? = nil) throws {
        if let storeURL = storeURL {
            guard let model = ToDoLocalDataStore.model else {
                throw ModelNotFound(modelName: Self.modelName)
            }
            container = try NSPersistentContainer.load(name: Self.modelName, model: model, url: storeURL)
            debugPrint("DB>> Stored DB in \(storeURL.absoluteString)")
        } else {
            container = NSPersistentContainer(name: Self.modelName)
            container.loadPersistentStores { _, error in
                if let error = error {
                    debugPrint("Error Loading Core Data - \(error)")
                }
            }
        }
        context = container.newBackgroundContext()
        whereIsMySQLite()
    }

    deinit { cleanUpReferencesToPersistentStores() }

    // MARK: - CRUD Methods using async/await

    func insert(pdfDatas: [ToDoCoreDataModel]) async throws -> Bool {
        try await perform { context in
          
            pdfDatas.forEach { model in
                let entity = ToDoEntity(context: context)
                entity.id = model.id
                entity.note = model.note
                entity.isDone = model.isDone
            }

            try context.save()
            return true
        }
    }

    func retrieve() async throws -> [ToDoCoreDataModel] {
        try await perform { context in
            let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            let results = try context.fetch(request)
            return results.map { $0.toCoreDataModel() }
        }
    }

    
    func update(updatedData: ToDoCoreDataModel) async throws -> ToDoCoreDataModel {
        let results = try await filter(parameters: ["id": updatedData.id])

        guard let entity = results.first else {
            throw NSError(domain: "UpdateError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entity not found for id: \(updatedData.id)"])
        }

        return try await perform { context in
            // Get the managed object in the current context
            let objectInContext = try context.existingObject(with: entity.objectID) as! ToDoEntity
            objectInContext.convertFromCoreDataModel(coreData: updatedData)
            try context.save()
            return updatedData
        }
    }

    func delete(id: String) async throws -> Bool {
        let results = try await filter(parameters: ["id": id])
        
        guard let entity = results.first else {
            throw NSError(domain: "DeleteError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entity not found for key: \(id)"])
        }

        return try await perform { context in
            let objectInContext = try context.existingObject(with: entity.objectID)
            context.delete(objectInContext)
            try context.save()
            return true
        }
    }



    func filter(parameters: [String: Any]) async throws -> [ToDoEntity] {
        try await perform { context in
            let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()

            let predicates = parameters.map { key, value in
                NSPredicate(format: "%K == %@", argumentArray: [key, value])
            }

            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            return try context.fetch(request)
        }
    }

    // MARK: - Generic Async CoreData Perform

    private func perform<T>(_ action: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let result = try action(self.context)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Helpers

    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

    private func whereIsMySQLite() {
        if let path = NSPersistentContainer.defaultDirectoryURL().path.removingPercentEncoding {
            debugPrint("DB Location: \(path)")
        }
    }
}
