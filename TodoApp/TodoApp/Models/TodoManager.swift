import UIKit

class TodoManager {
    static let shared = TodoManager()
    private init() {}
    
    var todoItems: [TodoItem] = []
    var completedItems: [TodoItem] = []
}

