//
//  ToDoTestHelper.swift
//  CoreDataWithTestTests
//
//  Created by Habibur Rahman on 15/5/25.
//

import Foundation
@testable import CoreDataWithTest

final class ToDoTestHelper {
    static func makeDummyTodoCoreDataModel(id: String =  UUID().uuidString, note: String = "Sample Note", isDone: Bool = false) -> ToDoCoreDataModel {
        return ToDoCoreDataModel(id: id , note: note, isDone: isDone)
    }
    
    
    
}
