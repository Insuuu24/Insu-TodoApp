

import UIKit

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

        setupNavigationBar()
        setupTableView()

    }
    

    
    // MARK: - Navigation Bar
    
    private func setupNavigationBar() {
        
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
    
    private func setupTableView() {
        view.addSubview(listTableView)
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")

        listTableView.estimatedRowHeight = 50.0
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

        if let trashImage = UIImage(systemName: "trash") {
            deleteAction.image = trashImage
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "완료") { (action, view, completionHandler) in
            let completedItem = self.todoItems[indexPath.row]
            TodoManager.shared.completedItems.append(completedItem) // 완료한 목록에 추가
            TodoManager.shared.todoItems.remove(at: indexPath.row) // 현재 목록에서 제거
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        completeAction.backgroundColor = .blue // 예시로 파란색 설정

        return UISwipeActionsConfiguration(actions: [completeAction])
    }


    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    

}

// MARK: - TodoAddViewControllerDelegate

extension TodoListViewController: TodoAddViewControllerDelegate {
    func didAddTodoItem(_ item: TodoItem) {
        TodoManager.shared.todoItems.append(item) // 여기에서도 TodoManager를 사용하여 항목 추가
        listTableView.reloadData()
    }
}
