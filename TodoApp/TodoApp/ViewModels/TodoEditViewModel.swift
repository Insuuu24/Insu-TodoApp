//
//  TodoEditViewModel.swift
//  TodoApp
//
//  Created by Insu on 2023/09/21.
//

import UIKit
import CoreData

final class TodoEditViewModel {

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

    func updateTodo(content: String?, item: TodoData, completion: (Bool) -> Void) {
        guard let content = content, !content.isEmpty,
              let category = selectedCategory,
              let date = selectedDate
        else {
            completion(false)
            return
        }

        item.content = content
        item.category = category
        item.date = date

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
            completion(true)
        } catch {
            print("Error saving updated todo item: \(error)")
            completion(false)
        }
    }
}
