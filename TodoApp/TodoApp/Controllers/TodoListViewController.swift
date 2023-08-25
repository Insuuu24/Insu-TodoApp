import UIKit
import Then
import SnapKit

class TodoListViewController: UIViewController {
    
    // MARK: - Properties
    
    var todoItems: [TodoItem] {
        get { return TodoManager.shared.todoItems }
        set { TodoManager.shared.todoItems = newValue }
    }

    private let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNav()
        configureUI()

    }
    
    // MARK: - Navigation Bar
    
    private func configureNav() {
        navigationItem.title = "Todo List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white

        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    @objc private func addButtonTapped() {
        let addTodoVC = TodoAddViewController()
        addTodoVC.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addTodoVC)
        navigationController.modalPresentationStyle = .pageSheet
        let sheet = navigationController.presentationController as? UISheetPresentationController
        sheet?.detents = [.medium()]
        sheet?.prefersGrabberVisible = true
        sheet?.preferredCornerRadius = 25
        sheet?.animateChanges {
            sheet?.selectedDetentIdentifier = .medium
        }
        present(navigationController, animated: true, completion: nil)
    }

    
    // MARK: - Setup Layout
    
    private func configureUI() {
        view.addSubview(listTableView)
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")

        listTableView.estimatedRowHeight = 100
        listTableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: view.topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
        let item = todoItems[indexPath.row]
        
        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 데이터 배열에서 항목을 삭제
            todoItems.remove(at: indexPath.row)
            
            // 테이블 뷰에서 해당 셀을 삭제
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            TodoManager.shared.todoItems.remove(at: indexPath.row) // 여기에서도 TodoManager를 사용하여 항목 삭제
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            let completedItem = self.todoItems[indexPath.row]
            TodoManager.shared.completedItems.append(completedItem)
            TodoManager.shared.todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        completeAction.image = UIImage(systemName: "text.badge.checkmark")
        completeAction.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [completeAction])
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = TodoEditViewController()
        editVC.delegate = self
        editVC.todoItem = todoItems[indexPath.row]
        editVC.todoItemIndex = indexPath.row
        
        let navigationController = UINavigationController(rootViewController: editVC)
        navigationController.modalPresentationStyle = .pageSheet
        let sheet = navigationController.presentationController as? UISheetPresentationController
        sheet?.detents = [.medium()]
        sheet?.prefersGrabberVisible = true
        sheet?.preferredCornerRadius = 25
        sheet?.animateChanges {
            sheet?.selectedDetentIdentifier = .medium
        }
        present(navigationController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - TodoAddViewControllerDelegate

extension TodoListViewController: TodoAddViewControllerDelegate {
    func didAddTodoItem(_ item: TodoItem) {
        TodoManager.shared.todoItems.append(item)
    
        let newIndexPath = IndexPath(row: todoItems.count - 1, section: 0)

        // 셀 추가 + 애니메이션
        listTableView.beginUpdates()
        listTableView.insertRows(at: [newIndexPath], with: .automatic)
        listTableView.endUpdates()
    }
}

// MARK: - TodoEditViewControllerDelegate

extension TodoListViewController: TodoEditViewControllerDelegate {
    func didUpdateTodoItem(_ item: TodoItem, at index: Int) {
        TodoManager.shared.todoItems[index] = item
        
        let indexPath = IndexPath(row: index, section: 0)
        listTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
