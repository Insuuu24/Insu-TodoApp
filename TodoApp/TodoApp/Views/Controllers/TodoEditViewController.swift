import UIKit
import Then
import SnapKit

protocol TodoEditViewControllerDelegate: AnyObject {
    func didUpdateTodoItem(_ item: TodoItem, at index: Int)
}

final class TodoEditViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: TodoEditViewControllerDelegate?
    var selectedTodoItem: TodoItem?
    var selectedIndex: Int?
    private var selectedDate: Date?
    private var selectedCategory: String?
    private let categories = ["과제📚", "독서📔", "운동🏃🏻", "프로젝트🧑🏻‍💻", "기타"]
    private var categoryButtons: [UIButton] = []
    
    private let todoHeaderLabel = UILabel().then {
        $0.text = "Todo"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private let todoTextField = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = Constant.textFieldBorderColor
        $0.layer.cornerRadius = 10
    }

    private lazy var borderView = UIView().then {
        $0.backgroundColor = Constant.textFieldBorderColor
        $0.layer.cornerRadius = 10
    }
    
    private let dateHeaderLabel = UILabel().then {
        $0.text = "Date"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private let selectedDateLabel = UILabel().then {
        $0.text = "선택한 날짜 없음"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .separator
    }
    
    private lazy var calendarButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "calendar"), for: .normal)
        $0.tintColor = .separator
        $0.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
    }

    private lazy var categoryStackView = UIStackView(arrangedSubviews: categoryButtons).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [selectedDateLabel, calendarButton]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private lazy var saveButton = UIButton(type: .system).then {
        $0.setTitle("저장", for: .normal)
        $0.backgroundColor = .systemGray4
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(updateSaveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCategoryButtons()
        configureNav()
        configureUI()
        populateUIWithSelectedTodoItem()
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "Todo 편집"
        
        let navigationBarAppearance = UINavigationBarAppearance().then {
            $0.configureWithDefaultBackground()
            $0.backgroundColor = .white
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func populateUIWithSelectedTodoItem() {
        if let selectedTodoItem = selectedTodoItem {
            todoTextField.text = selectedTodoItem.content
            
            selectedDate = selectedTodoItem.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            selectedDateLabel.text = dateFormatter.string(from: selectedTodoItem.date)
            selectedDateLabel.textColor = .black
            
            selectedCategory = selectedTodoItem.category
            if let index = categories.firstIndex(of: selectedTodoItem.category) {
                categoryButtons.forEach { button in
                    button.backgroundColor = .white
                    button.setTitleColor(.black, for: .normal)
                }
                let selectedButton = categoryButtons[index]
                selectedButton.backgroundColor = UIColor(red: 0.34, green: 0.37, blue: 0.49, alpha: 1.00)
                selectedButton.setTitleColor(.white, for: .normal)
            }
        }
        updateSaveButtonState()
    }
    
    private func configureCategoryButtons() {
        for (index, category) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.tag = index
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            categoryButtons.append(button)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(categoryStackView, todoHeaderLabel, todoTextField, dateHeaderLabel, borderView, saveButton)
        borderView.addSubview(stackView)
        todoTextField.delegate = self
        
        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }
        
        todoHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(categoryStackView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(16)
        }
        
        todoTextField.snp.makeConstraints {
            $0.top.equalTo(todoHeaderLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        dateHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(todoTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(dateHeaderLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        calendarButton.snp.makeConstraints {
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        todoTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: todoTextField.frame.height))
        todoTextField.leftViewMode = .always
    }
    
    private func isFormComplete() -> Bool {
        return selectedCategory != nil && selectedDate != nil && !(todoTextField.text?.isEmpty ?? true)
    }
    
    private func updateSaveButtonState() {
        if isFormComplete() {
            saveButton.backgroundColor = UIColor(red: 0.34, green: 0.37, blue: 0.49, alpha: 1.00)
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = .systemGray4
            saveButton.isEnabled = false
        }
    }
    
    // MARK: - Actions
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        categoryButtons.forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
        sender.backgroundColor = UIColor(red: 0.34, green: 0.37, blue: 0.49, alpha: 1.00)
        sender.setTitleColor(.white, for: .normal)
        selectedCategory = categories[sender.tag]
        updateSaveButtonState()
    }
    
    @objc private func calendarButtonTapped() {
        let datePickerPopup = DatePickerPopupView(frame: view.bounds)
        datePickerPopup.onSelectDate = { [weak self] selectedDate in
            guard let self = self else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.selectedDateLabel.text = dateFormatter.string(from: selectedDate)
            self.selectedDateLabel.textColor = .black
            
            self.selectedDate = selectedDate
            self.updateSaveButtonState()
        }
        datePickerPopup.alpha = 0
        view.addSubview(datePickerPopup)
        
        UIView.animate(withDuration: 0.2) {
            datePickerPopup.alpha = 1
        }
    }
    
    @objc private func updateSaveButtonTapped() {
        guard saveButton.isEnabled,
              let content = todoTextField.text,
              let date = selectedDate,
              let category = selectedCategory,
              let index = selectedIndex
        else { return }

        let updatedTodoItem = TodoItem(content: content, category: category, date: date)
        delegate?.didUpdateTodoItem(updatedTodoItem, at: index)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension TodoEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonTapped()
    }
}
