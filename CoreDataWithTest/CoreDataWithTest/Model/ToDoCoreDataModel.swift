//
//  ToDoCoreDataModel.swift
//  CoreDataWithTest
//
//  Created by Habibur Rahman on 12/5/25.
//

import Foundation

class ToDoCoreDataModel {
    var id: String
    var note: String
    var isDone: Bool

    init(id: String, note: String, isDone: Bool) {
        self.id = id
        self.note = note
        self.isDone = isDone
    }
}

extension ToDoCoreDataModel: Equatable {
    static func == (lhs: ToDoCoreDataModel, rhs: ToDoCoreDataModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.note == rhs.note &&
            lhs.isDone == rhs.isDone
    }
}

extension ToDoCoreDataModel {
    func toTodoModelData() -> TodoModel {
        return TodoModel(id: id, note: note, isDone: isDone)
    }
}
