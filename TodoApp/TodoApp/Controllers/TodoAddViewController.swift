//
//  TodoAddViewController.swift
//  TodoApp
//
//  Created by Insu on 2023/08/06.
//

import UIKit

protocol TodoAddViewControllerDelegate: AnyObject {
    func didAddTodoItem(_ item: TodoItem)
}

class TodoAddViewController: UIViewController {

    // MARK: - Properties
    
    weak var delegate: TodoAddViewControllerDelegate?
    
    private var selectedColor: UIColor?
    private var selectedDate: Date?

    
    let colorPickerHeader: UILabel = {
        let label = UILabel()
        label.text = "Color"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var redButton: UIButton = createColorButton(color: .red)
    lazy var greenButton: UIButton = createColorButton(color: .green)
    lazy var blueButton: UIButton = createColorButton(color: .blue)
    lazy var pinkButton: UIButton = createColorButton(color: .systemPink)

    lazy var colorsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [redButton, greenButton, blueButton, pinkButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let todoHeader: UILabel = {
        let label = UILabel()
        label.text = "Todo"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let todoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        return textField
    }()

    lazy var borderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    let dateHeader: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 날짜 없음"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .separator
        return label
    }()
    
    lazy var calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .separator
        button.addTarget(self, action: #selector(handleCalendarButton), for: .touchUpInside)
        return button
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectedDateLabel, calendarButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()


    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Todo 추가"
        view.backgroundColor = .white
        
        todoTextField.delegate = self
        
        setupNavigationBar()
        setupLayout()

    }
    
    // MARK: - Navigation Bar
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    
    
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        view.addSubview(colorPickerHeader)
        view.addSubview(colorsStackView)
        view.addSubview(todoHeader)
        view.addSubview(todoTextField)
        view.addSubview(dateHeader)
        view.addSubview(borderView)
        borderView.addSubview(stackView)
        view.addSubview(saveButton)
        
        
        colorPickerHeader.translatesAutoresizingMaskIntoConstraints = false
        colorsStackView.translatesAutoresizingMaskIntoConstraints = false
        todoHeader.translatesAutoresizingMaskIntoConstraints = false
        todoTextField.translatesAutoresizingMaskIntoConstraints = false
        dateHeader.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        selectedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            colorPickerHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            colorPickerHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            colorsStackView.topAnchor.constraint(equalTo: colorPickerHeader.bottomAnchor, constant: 10),
            colorsStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            colorsStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            colorsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //colorsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            
            todoHeader.topAnchor.constraint(equalTo: colorsStackView.bottomAnchor, constant: 20),
            todoHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            todoTextField.topAnchor.constraint(equalTo: todoHeader.bottomAnchor, constant: 10),
            todoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            todoTextField.heightAnchor.constraint(equalToConstant: 40),
            
            dateHeader.topAnchor.constraint(equalTo: todoTextField.bottomAnchor, constant: 20),
            dateHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            borderView.topAnchor.constraint(equalTo: dateHeader.bottomAnchor, constant: 10),
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            borderView.heightAnchor.constraint(equalToConstant: 40),

            stackView.topAnchor.constraint(equalTo: borderView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -5),

            calendarButton.widthAnchor.constraint(equalToConstant: 25),
            calendarButton.heightAnchor.constraint(equalToConstant: 25),
            
            saveButton.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        

    }
    

    // MARK: - Method & Action
    
    func getSelectedColor() -> UIColor? {
        return selectedColor
    }
    
    private func createColorButton(color: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        
        let diameter: CGFloat = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: diameter).isActive = true
        button.widthAnchor.constraint(equalToConstant: diameter).isActive = true
        button.layer.cornerRadius = diameter / 2
        
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }
    
    private func updateButtonBorders() {
        
        for button in [redButton, greenButton, blueButton, pinkButton] {
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
        }
        
        if selectedColor == .red {
            redButton.layer.borderWidth = 3
            redButton.layer.borderColor = UIColor.lightGray.cgColor
        } else if selectedColor == .green {
            greenButton.layer.borderWidth = 3
            greenButton.layer.borderColor = UIColor.lightGray.cgColor
        } else if selectedColor == .blue {
            blueButton.layer.borderWidth = 3
            blueButton.layer.borderColor = UIColor.lightGray.cgColor
        } else if selectedColor == .systemPink {
            pinkButton.layer.borderWidth = 3
            pinkButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @objc func colorButtonTapped(sender: UIButton) {
        if sender == redButton {
            selectedColor = .red
        } else if sender == greenButton {
            selectedColor = .green
        } else if sender == blueButton {
            selectedColor = .blue
        } else if sender == pinkButton {
            selectedColor = .systemPink
        }

        updateButtonBorders()
        updateSaveButtonState()
    }


    @objc func handleCalendarButton() {
        didTapCalendarButton()
    }

    func didTapCalendarButton() {
        let datePickerPopup = DatePickerPopupView(frame: self.view.bounds)
        datePickerPopup.onSelectDate = { [weak self] selectedDate in
            guard let self = self else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.selectedDateLabel.text = dateFormatter.string(from: selectedDate)
            self.selectedDateLabel.textColor = .black
            
            self.selectedDate = selectedDate
        }

        datePickerPopup.alpha = 0
        self.view.addSubview(datePickerPopup)

        UIView.animate(withDuration: 0.2) {
            datePickerPopup.alpha = 1
        }
        updateSaveButtonState()
    }
    
    func isFormComplete() -> Bool {
        return selectedColor != nil && !(todoTextField.text?.isEmpty ?? true)
    }

    func updateSaveButtonState() {
        if isFormComplete() {
            saveButton.backgroundColor = .systemBlue
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = .lightGray
            saveButton.isEnabled = false
        }
    }


    @objc func saveButtonTapped() {
        guard let content = todoTextField.text, !content.isEmpty else {
            return
        }

        let finalSelectedColor = selectedColor ?? .red
        let todoItem = TodoItem(color: finalSelectedColor, content: content, date: selectedDate ?? Date())

        delegate?.didAddTodoItem(todoItem)

        dismiss(animated: true, completion: nil)
    }



    
    
    
    
    
    
}


// MARK: - UITextFieldDelegate

// UITextFieldDelegate 메서드 사용을 위해
extension TodoAddViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
}
