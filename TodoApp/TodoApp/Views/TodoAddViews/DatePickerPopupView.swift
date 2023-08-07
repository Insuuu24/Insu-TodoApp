//
//  DatePickerPopupView.swift
//  TodoApp
//
//  Created by Insu on 2023/08/07.
//

import UIKit

class DatePickerPopupView: UIView {
    
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        return picker
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    var onSelectDate: ((Date) -> Void)?
    var onCancel: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(datePicker)
        contentView.addSubview(doneButton)
        contentView.addSubview(cancelButton)
        
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20),
            contentView.widthAnchor.constraint(equalToConstant: 320),
            
            datePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }


    
    @objc private func handleDone() {
        onSelectDate?(datePicker.date)
        removeFromSuperview()
    }
    
    @objc private func handleCancel() {
        onCancel?()
        removeFromSuperview()
    }
}
