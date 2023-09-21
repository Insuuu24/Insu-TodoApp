//
//  TodoAddViewModel.swift
//  TodoApp
//
//  Created by Insu on 2023/09/21.
//

import UIKit
import CoreData

final class TodoAddViewModel {

    // MARK: - Output

    var selectedDate: Date?
    var selectedCategory: String?
    let categories = ["과제📚", "독서📔", "운동🏃🏻", "프로젝트🧑🏻‍💻", "기타"]

    // MARK: - Input

    func selectCategory(at index: Int) {
        selectedCategory = categories[index]
    }

    func selectDate(_ date: Date) {
        selectedDate = date
    }

    // MARK: - Logics

    func isFormComplete(content: String?) -> Bool {
        return selectedCategory != nil && selectedDate != nil && !(content?.isEmpty ?? true)
    }

    func saveTodo(content: String?, completion: (TodoData?) -> Void) {
        guard let content = content, !content.isEmpty,
              let category = selectedCategory,
              let date = selectedDate
        else {
            completion(nil)
            return
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let todoItem = TodoData(context: context)
        todoItem.content = content
        todoItem.category = category
        todoItem.date = date
        completion(todoItem)
    }
}
