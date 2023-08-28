import UIKit

struct TodoItem: Codable {
    var content: String
    var category: String
    var date: Date
    
    init(content: String, category: String, date: Date) {
        self.content = content
        self.category = category
        self.date = date
    }
}
