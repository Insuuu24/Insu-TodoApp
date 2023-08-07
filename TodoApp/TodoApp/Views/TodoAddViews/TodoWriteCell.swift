//
//  TodoWriteCell.swift
//  TodoApp
//
//  Created by Insu on 2023/08/07.
//

import UIKit

class TodoWriteCell: UITableViewCell {
    
    // MARK: - Properties

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

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        contentView.addSubview(todoHeader)
        contentView.addSubview(todoTextField)

        todoHeader.translatesAutoresizingMaskIntoConstraints = false
        todoTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            todoHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            todoHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            todoTextField.topAnchor.constraint(equalTo: todoHeader.bottomAnchor, constant: 5), // 변경됨
            todoTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            todoTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            todoTextField.heightAnchor.constraint(equalToConstant: 40),
            todoTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
