import UIKit
import Then
import SnapKit

final class TodoListViewController: UIViewController {

    // MARK: - Properties

    var todoItems: [TodoData] {
        get { return TodoDataManager.shared.todoItems }
        set { TodoDataManager.shared.todoItems = newValue }
    }

    private let viewModel = TodoListViewModel()
    private let barColor = UIView()

    private let listTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
        $0.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")
        $0.estimatedRowHeight = 100
        $0.rowHeight = UITableView.automaticDimension
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let categoryScrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var todoAddButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 22.5
        $0.addTarget(self, action: #selector(todoAddButtonTapped), for: .touchUpInside)
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNav()
        configureUI()
        updateCategories(viewModel.todayCategories)
        viewModel.loadItemsForCategory("전체")
    }

    // MARK: - Helper

    private func configureNav() {
        let navigationBarAppearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.shadowColor = nil
        }

        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        let logoImage = UIImage(named: "logo.png")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        logoImageView.frame = container.bounds
        container.addSubview(logoImageView)
        navigationItem.titleView = container
    }

    private func configureCategoryLabels() {
        let categories = ["전체", "과제📚", "독서📔", "운동🏃🏻", "프로젝트🧑🏻‍💻", "기타"]
        let categoryLabels = categories.map { category -> UIView in
            let label = UILabel()
            label.text = category
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.backgroundColor = .white
            label.textColor = .lightGray
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true

            label.snp.makeConstraints {
                $0.width.greaterThanOrEqualTo(60)
            }

            return label
        }
        categoryStackView.distribution = .fillEqually
        categoryLabels.forEach { categoryStackView.addArrangedSubview($0) }
    }

    private func configureUI() {
        view.addSubviews(listTableView, categoryScrollView, todoAddButton)
        categoryScrollView.addSubview(categoryStackView)

        listTableView.delegate = self
        listTableView.dataSource = self

        configureCategoryLabels()

        categoryScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(40)
        }

        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(categoryScrollView.snp.top)
            $0.leading.equalTo(categoryScrollView.snp.leading)
            $0.trailing.equalTo(categoryScrollView.snp.trailing)
            $0.bottom.equalTo(categoryScrollView.snp.bottom)
            $0.height.equalTo(categoryScrollView.snp.height)
        }

        listTableView.snp.makeConstraints {
            $0.top.equalTo(categoryScrollView.snp.bottom)
            $0.bottom.equalTo(view.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
        }

        todoAddButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(25)
            $0.height.equalTo(45)
        }
    }

    private func updateCategories(_ categories: [String]) {
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let categoryLabels = categories.map { category -> UIView in
            let label = UILabel()
            label.text = category
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.backgroundColor = .white
            label.textColor = category == "전체" ? .black : .lightGray
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true

            label.snp.makeConstraints {
                $0.width.greaterThanOrEqualTo(60)
            }

            return label
        }

        categoryLabels.forEach { categoryStackView.addArrangedSubview($0) }

        barColor.backgroundColor = Constant.appColor
        categoryScrollView.addSubview(barColor)
        barColor.snp.makeConstraints {
            $0.bottom.equalTo(categoryScrollView.snp.bottom)
            $0.height.equalTo(3)
            $0.leading.equalTo(categoryStackView.arrangedSubviews.first!.snp.leading)
            $0.trailing.equalTo(categoryStackView.arrangedSubviews.first!.snp.trailing)
        }
    }

    // MARK: - Actions

    @objc private func categoryTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        guard label.text != nil else { return }

        for view in categoryStackView.arrangedSubviews {
            if let label = view as? UILabel {
                label.textColor = .lightGray
            }
        }

        label.textColor = .black

        barColor.snp.remakeConstraints {
            $0.bottom.equalTo(categoryScrollView.snp.bottom)
            $0.height.equalTo(3)
            $0.leading.equalTo(label.snp.leading)
            $0.trailing.equalTo(label.snp.trailing)
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        guard let selectedCategory = label.text else { return }
        viewModel.loadItemsForCategory(selectedCategory)
        listTableView.reloadData()
    }

    @objc private func todoAddButtonTapped() {
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.displayedItems.count == TodoDataManager.shared.todoItems.count ? viewModel.sections.count : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.displayedItems.count == TodoDataManager.shared.todoItems.count {
            let category = Array(viewModel.sections.keys)[section]
            return viewModel.sections[category]?.count ?? 0
        } else {
            return viewModel.displayedItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
        if viewModel.displayedItems.count == TodoDataManager.shared.todoItems.count {
            let category = Array(viewModel.sections.keys)[indexPath.section]
            guard let item = viewModel.sections[category]?[indexPath.row] else { return UITableViewCell() }
            cell.configure(with: item)
        } else {
            let item = viewModel.displayedItems[indexPath.row]
            cell.configure(with: item)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel.displayedItems.count == TodoDataManager.shared.todoItems.count {
            return Array(viewModel.sections.keys)[section]
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.displayedItems.count == TodoDataManager.shared.todoItems.count {
            let category = Array(viewModel.sections.keys)[section]
            return viewModel.sections[category]?.isEmpty ?? true ? 0.0 : 30.0
        } else {
            return 0.0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let category = viewModel.todayCategories[section]
        if let items = viewModel.sections[category], !items.isEmpty {
            return 10.0
        } else {
            return 0.0
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            self.viewModel.deleteItem(at: indexPath.row)
            self.viewModel.loadItemsForCategory("전체")
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel.completeItem(at: indexPath.row)
            self.viewModel.loadItemsForCategory("전체")
            tableView.reloadData()
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
        let selectedItem = viewModel.displayedItems[indexPath.row]
        let selectedIndex = indexPath.row
        editVC.selectedTodoItem = selectedItem
        editVC.selectedIndex = selectedIndex

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
    func didAddTodoItem(_ item: TodoData) {
        viewModel.addItem(item)
        viewModel.loadItemsForCategory("전체")
        listTableView.reloadData()
    }
}

// MARK: - TodoEditViewControllerDelegate

extension TodoListViewController: TodoEditViewControllerDelegate {
    func didUpdateTodoItem(_ item: TodoData, at index: Int) {
        viewModel.updateItem(item, at: index)
        viewModel.loadItemsForCategory("전체")
        listTableView.reloadData()
    }
}
