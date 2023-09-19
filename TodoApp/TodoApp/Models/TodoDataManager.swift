import UIKit
import CoreData

class TodoDataManager {
    static let shared = TodoDataManager()
    private init() {
        loadTodoItems()
        loadCompletedItems()
    }
    
    private let todoItemsKey = "todoItems"
    private let completedItemsKey = "completedItems"
    
    var todoItems: [TodoData] = []
    var completedItems: [TodoData] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTodoItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadTodoItems(with request: NSFetchRequest<TodoData> = TodoData.fetchRequest()) {
        do {
            todoItems = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func saveCompletedItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadCompletedItems(with request: NSFetchRequest<TodoData> = TodoData.fetchRequest()) {
        do {
            completedItems = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}
