import UIKit

class TodoDataManager {
    static let shared = TodoDataManager()
    private init() {
        loadTodoItems()
        loadCompletedItems()
    }
    
    private let todoItemsKey = "todoItems"
    private let completedItemsKey = "completedItems"
    
    var todoItems: [TodoItem] = []
    var completedItems: [TodoItem] = []
    
    func saveTodoItems() {
        if let encodedData = try? JSONEncoder().encode(todoItems) {
            UserDefaults.standard.set(encodedData, forKey: todoItemsKey)
        }
    }
    
    func loadTodoItems() {
        if let savedData = UserDefaults.standard.data(forKey: todoItemsKey),
            let decodedData = try? JSONDecoder().decode([TodoItem].self, from: savedData) {
            todoItems = decodedData
        }
    }
    
    func saveCompletedItems() {
        if let encodedData = try? JSONEncoder().encode(completedItems) {
            UserDefaults.standard.set(encodedData, forKey: completedItemsKey)
        }
    }
    
    func loadCompletedItems() {
        if let savedData = UserDefaults.standard.data(forKey: completedItemsKey),
            let decodedData = try? JSONDecoder().decode([TodoItem].self, from: savedData) {
            completedItems = decodedData
        }
    }
}
