//
//  TodoListCell.swift
//  TodoApp
//
//  Created by Insu on 2023/08/08.
//

import UIKit

class TodoListCell: UITableViewCell {
    
    // MARK: - Properties
    
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    let todoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // 여러 줄 텍스트 표시 가능
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        contentView.addSubview(colorView)
        contentView.addSubview(todoLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 10),
            colorView.heightAnchor.constraint(equalToConstant: 10),
            
            todoLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            todoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            todoLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -10),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - configure
    
    func configure(with item: TodoItem) {
        self.colorView.backgroundColor = item.color
        self.todoLabel.text = item.content
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateLabel.text = formatter.string(from: item.date)
    }


}

