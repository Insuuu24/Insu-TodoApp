//
//  TodoCompleteViewController.swift
//  TodoApp
//
//  Created by Insu on 2023/08/06.
//

import UIKit

class TodoCompleteViewController: UIViewController {

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
