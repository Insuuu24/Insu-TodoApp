//
//  ViewController.swift
//  TodoApp
//
//  Created by Insu on 2023/08/06.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - Method & Action
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        let todoListAction = UIAction(title: "Todo List", image: UIImage(systemName: "list.bullet"), identifier: nil, discoverabilityTitle: nil) { [weak self] _ in
            guard let self = self else { return }
            let todoListVC = TodoListViewController()
            self.navigationController?.pushViewController(todoListVC, animated: true)
        }
        
        let todoCompleteListAction = UIAction(title: "완료한 Todo", image: UIImage(systemName: "checkmark.square"), identifier: nil, discoverabilityTitle: nil) { [weak self] _ in
            guard let self = self else { return }
            let todoCompleteVC = TodoCompleteViewController()
            self.navigationController?.pushViewController(todoCompleteVC, animated: true)
        }
        
        let menu = UIMenu(title: "Todo List Menu", identifier: nil, options: .displayInline, children: [todoCompleteListAction, todoListAction])
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true}
    
}
    
    
    
    
    
    



