import UIKit
import Then
import SnapKit

class TodoCompleteViewController: UIViewController {
    
    // MARK: - Properties
    
    private let completeListTableView: UITableView = {
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
        navigationItem.title = "완료한 Todo"
        
        let navigationBarAppearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
        }
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    // MARK: - Setup Layout
    
    private func configureUI() {
        view.addSubview(completeListTableView)
        
        completeListTableView.delegate = self
        completeListTableView.dataSource = self
        completeListTableView.register(TodoListCell.self, forCellReuseIdentifier: "CompletedTodoCell")

        completeListTableView.estimatedRowHeight = 50.0
        completeListTableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            completeListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            completeListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            completeListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            completeListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoCompleteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoDataManager.shared.completedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTodoCell", for: indexPath) as! TodoListCell
        let item = TodoDataManager.shared.completedItems[indexPath.row]
        
        cell.configure(with: item)
        cell.applyStrikeThrough()
        
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            TodoDataManager.shared.completedItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // 셀 터치 비활성화
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

}
