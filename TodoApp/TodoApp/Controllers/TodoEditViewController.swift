import UIKit
import Then
import SnapKit

protocol TodoEditViewControllerDelegate: AnyObject {
    func didUpdateTodoItem(_ item: TodoItem, at index: Int)
}

class TodoEditViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: TodoAddViewControllerDelegate?
    private var selectedDate: Date?
    private var selectedCategory: String?
    private let categories = ["과제📚", "독서📔", "운동🏃🏻", "프로젝트🧑🏻‍💻", "기타"]
    private var categoryButtons: [UIButton] = []
    
    
    private let todoHeaderLabel = UILabel().then {
        $0.text = "Todo"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private let todoTextField = UITextField().then {
        $0.borderStyle = .none
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 5
    }
    
    private lazy var borderView = UIView().then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 5
    }
    
    private let dateHeaderLabel = UILabel().then {
        $0.text = "Date"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private let selectedDateLabel = UILabel().then {
        $0.text = "선택한 날짜 없음"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .separator
    }
    
    private lazy var calendarButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "calendar"), for: .normal)
        $0.tintColor = .separator
        //$0.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
    }
    
    private let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
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
        //$0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        todoTextField.delegate = self
        configureNav()
        configureUI()
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
    
    
    private func configureUI() {
        view.addSubviews(categoryStackView, todoHeaderLabel, todoTextField, dateHeaderLabel, borderView, saveButton)
        borderView.addSubview(stackView)
        
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
    }
    
    private func didTapCalendarButton() {
        let datePickerPopup = DatePickerPopupView(frame: self.view.bounds)
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
        self.view.addSubview(datePickerPopup)
        
        UIView.animate(withDuration: 0.2) {
            datePickerPopup.alpha = 1
        }
        updateSaveButtonState()
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

//    // MARK: - Method & Action
//
//    func setupInitialData() {
//        if let item = todoItem {
//            selectedColor = item.color
//            updateButtonBorders()
//            todoTextField.text = item.content
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            selectedDateLabel.text = dateFormatter.string(from: item.date)
//            selectedDateLabel.textColor = .black
//            selectedDate = item.date
//        }
//    }
//
//    func getSelectedColor() -> UIColor? {
//        return selectedColor
//    }
//
//    private func createColorButton(color: UIColor) -> UIButton {
//        let button = UIButton()
//        button.backgroundColor = color
//
//        let diameter: CGFloat = 30
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: diameter).isActive = true
//        button.widthAnchor.constraint(equalToConstant: diameter).isActive = true
//        button.layer.cornerRadius = diameter / 2
//        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
//        return button
//    }
//
//    private func updateButtonBorders() {
//        for button in [yellowButton, greenButton, blueButton, pinkButton, indigoButton] {
//            button.layer.borderWidth = 0
//            button.layer.borderColor = UIColor.clear.cgColor
//        }
//
//        if selectedColor == .systemYellow {
//            yellowButton.layer.borderWidth = 3
//            yellowButton.layer.borderColor = UIColor.lightGray.cgColor
//        } else if selectedColor == .systemGreen {
//            greenButton.layer.borderWidth = 3
//            greenButton.layer.borderColor = UIColor.lightGray.cgColor
//        } else if selectedColor == .systemBlue {
//            blueButton.layer.borderWidth = 3
//            blueButton.layer.borderColor = UIColor.lightGray.cgColor
//        } else if selectedColor == .systemPink {
//            pinkButton.layer.borderWidth = 3
//            pinkButton.layer.borderColor = UIColor.lightGray.cgColor
//        } else if selectedColor == .systemIndigo {
//            indigoButton.layer.borderWidth = 3
//            indigoButton.layer.borderColor = UIColor.lightGray.cgColor
//        }
//    }
//
//    @objc private func colorButtonTapped(sender: UIButton) {
//        if sender == yellowButton {
//            selectedColor = .systemYellow
//        } else if sender == greenButton {
//            selectedColor = .systemGreen
//        } else if sender == blueButton {
//            selectedColor = .systemBlue
//        } else if sender == pinkButton {
//            selectedColor = .systemPink
//        } else if sender == indigoButton {
//            selectedColor = .systemIndigo
//        }
//
//        updateButtonBorders()
//        updateSaveButtonState()
//    }
//
//    @objc private func handleCalendarButton() {
//        didTapCalendarButton()
//    }
//
//    private func didTapCalendarButton() {
//        let datePickerPopup = DatePickerPopupView(frame: self.view.bounds)
//        datePickerPopup.onSelectDate = { [weak self] selectedDate in
//            guard let self = self else { return }
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            self.selectedDateLabel.text = dateFormatter.string(from: selectedDate)
//            self.selectedDateLabel.textColor = .black
//
//            self.selectedDate = selectedDate
//        }
//
//        datePickerPopup.alpha = 0
//        self.view.addSubview(datePickerPopup)
//
//        UIView.animate(withDuration: 0.2) {
//            datePickerPopup.alpha = 1
//        }
//        updateSaveButtonState()
//    }
//
//    private func isFormComplete() -> Bool {
//        return selectedColor != nil && !(todoTextField.text?.isEmpty ?? true)
//    }
//
//    private func updateSaveButtonState() {
//        if isFormComplete() {
//            saveButton.backgroundColor = UIColor(red: 0.51, green: 0.57, blue: 0.63, alpha: 1.00)
//            saveButton.isEnabled = true
//        } else {
//            saveButton.backgroundColor = .lightGray
//            saveButton.isEnabled = false
//        }
//    }
//
//    @objc private func saveButtonTapped() {
//        guard let content = todoTextField.text, !content.isEmpty,
//              let index = todoItemIndex else {
//            return
//        }
//
//        let finalSelectedColor = selectedColor ?? .systemYellow
//        let updatedTodoItem = TodoItem(color: finalSelectedColor, content: content, date: selectedDate ?? Date())
//
//        delegate?.didUpdateTodoItem(updatedTodoItem, at: index)
//
//        dismiss(animated: true, completion: nil)
//    }
}
//
// MARK: - UITextFieldDelegate

extension TodoEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.updateSaveButtonState()
        }
        return true
    }

}
