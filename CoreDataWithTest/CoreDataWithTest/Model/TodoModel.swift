//
//  TodoModel.swift
//  CoreDataWithTest
//
//  Created by Habibur Rahman on 12/5/25.
//

import Foundation

class TodoModel{
    var id : String
    var note : String
    var isDone : Bool
    
    init(id: String, note: String, isDone: Bool) {
        self.id = id
        self.note = note
        self.isDone = isDone
    }
}

extension TodoModel {
    func toCoreDataModel() -> ToDoCoreDataModel {
        return ToDoCoreDataModel(id: id, note: note, isDone: isDone)
    }
}
