//
//  TodoListViewModel.swift
//  TodoApp
//
//  Created by Insu on 2023/09/21.
//

import UIKit
import CoreData

final class TodoListViewModel {

    // MARK: - Output

    var displayedItems: [TodoData] = []
    var sections: [String: [TodoData]] = [:]
    var todayCategories = ["전체", "과제📚", "독서📔", "운동🏃🏻", "프로젝트🧑🏻‍💻", "기타"]

    // MARK: - Input

    func loadItemsForCategory(_ category: String) {
        if category == "전체" {
            displayedItems = TodoDataManager.shared.todoItems
            sections = [:]
            for category in todayCategories where category != "전체" {
                let items = TodoDataManager.shared.todoItems.filter { $0.category == category }
                if !items.isEmpty {
                    sections[category] = items
                }
            }
        } else {
            displayedItems = TodoDataManager.shared.todoItems.filter { $0.category == category }
            sections = [category: displayedItems]
        }
    }

    // MARK: - Logics

    func addItem(_ item: TodoData) {
        TodoDataManager.shared.todoItems.append(item)
        TodoDataManager.shared.saveTodoItems()
    }

    func updateItem(_ item: TodoData, at index: Int) {
        TodoDataManager.shared.todoItems[index] = item
        TodoDataManager.shared.saveTodoItems()
    }

    func deleteItem(at index: Int) {
        let itemToDelete = TodoDataManager.shared.todoItems[index]
        TodoDataManager.shared.context.delete(itemToDelete)
        TodoDataManager.shared.todoItems.remove(at: index)
        TodoDataManager.shared.saveTodoItems()
    }

    func completeItem(at index: Int) {
        let completedItem = TodoDataManager.shared.todoItems[index]
        TodoDataManager.shared.completedItems.append(completedItem)
        TodoDataManager.shared.todoItems.remove(at: index)
        TodoDataManager.shared.saveTodoItems()
        TodoDataManager.shared.saveCompletedItems()
    }
}
