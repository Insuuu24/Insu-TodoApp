//
//  TabBarController.swift
//  TodoApp
//
//  Created by Insu on 2023/09/15.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }

    private func setupTabBar() {
        let todoListVC = TodoListViewController()
        let todoListNavController = UINavigationController(rootViewController: todoListVC)
        todoListNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "list.clipboard"), selectedImage: UIImage(systemName: "list.clipboard.fill"))

        let todoCompleteVC = TodoCompleteViewController()
        let todoCompleteNavController = UINavigationController(rootViewController: todoCompleteVC)
        todoCompleteNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "checkmark.circle"), selectedImage: UIImage(systemName: "checkmark.circle.fill"))

        let profileVC = ProfileViewController()
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        let tabBarList = [todoListNavController, todoCompleteNavController, profileNavController]

        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = UIColor(red: 0.753, green: 0.753, blue: 0.753, alpha: 1)
        self.tabBar.isHidden = false

        viewControllers = tabBarList
    }
}
