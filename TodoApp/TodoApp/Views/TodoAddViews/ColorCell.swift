//
//  ColorCell.swift
//  TodoApp
//
//  Created by Insu on 2023/08/07.
//

import UIKit

class ColorCell: UITableViewCell {
    
    // MARK: - Properties
    
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
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
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
        contentView.addSubview(colorPickerHeader)
        contentView.addSubview(colorsStackView)
        
        colorPickerHeader.translatesAutoresizingMaskIntoConstraints = false
        colorsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        colorsStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        NSLayoutConstraint.activate([
            colorPickerHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            colorPickerHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            colorsStackView.topAnchor.constraint(equalTo: colorPickerHeader.bottomAnchor, constant: 5),
            colorsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    private func createColorButton(color: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }

    
    // MARK: - Method & Action
    
    @objc func colorButtonTapped(sender: UIButton) {
        // 색상 버튼이 눌릴 때의 동작 구현
        if sender == redButton {
            print("레드버튼 클릭")
        } else if sender == greenButton {
            print("초록버튼 클릭")
        } else if sender == blueButton {
            print("파랑버튼 클릭")
        } else if sender == pinkButton {
            print("분홍버튼 클릭")
        }
    }
}
