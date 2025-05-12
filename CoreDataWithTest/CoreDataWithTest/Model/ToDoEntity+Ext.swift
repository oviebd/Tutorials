//
//  ToDoEntity+Ext.swift
//  CoreDataWithTest
//
//  Created by Habibur Rahman on 12/5/25.
//

import Foundation
import CoreData

extension ToDoEntity {
    
    static func find(in context: NSManagedObjectContext) throws -> ToDoEntity? {
        let request = NSFetchRequest<ToDoEntity>(entityName: entity().name!)
        return try context.fetch(request).first
    }

    static func getInstance(in context: NSManagedObjectContext) throws -> ToDoEntity {
        let instance = try find(in: context)
        return instance ?? ToDoEntity(context: context)
    }
    
    func toCoreDataModel() -> ToDoCoreDataModel {
        return ToDoCoreDataModel(id: id ?? UUID().uuidString, note: note ?? "", isDone: isDone)
    }
    
    func convertFromCoreDataModel(coreData : ToDoCoreDataModel )   {
        self.id = coreData.id
        self.note = coreData.note
        self.isDone = coreData.isDone
    }
    
}
