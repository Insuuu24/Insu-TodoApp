//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by Insu on 2023/08/06.
//

import UIKit

class TodoListViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var listTableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
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
        guard let addTodoVC = self.storyboard?.instantiateViewController(withIdentifier: "TodoAddViewController") as? TodoAddViewController else { return }
        let navigationController = UINavigationController(rootViewController: addTodoVC)
        navigationController.modalPresentationStyle = .pageSheet
        let sheet = navigationController.presentationController as? UISheetPresentationController
        sheet?.detents = [.medium()]
        sheet?.animateChanges {
            sheet?.selectedDetentIdentifier = .medium
        }
        present(navigationController, animated: true, completion: nil)
    }

}
