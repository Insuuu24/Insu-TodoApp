

import UIKit

class TodoCompleteViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    

    // MARK: - Navigation Bar
    
    private func setupNavigationBar() {
        
        navigationItem.title = "완료한 Todo"
        
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
}
