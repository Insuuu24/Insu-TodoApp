//
//  DateCell.swift
//  TodoApp
//
//  Created by Insu on 2023/08/07.
//

import UIKit

protocol DateCellDelegate: AnyObject {
    func didTapCalendarButton(in cell: DateCell)
}

class DateCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: DateCellDelegate?
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        contentView.addSubview(dateHeader)
        contentView.addSubview(borderView)
        borderView.addSubview(stackView)

        dateHeader.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        selectedDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dateHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            borderView.topAnchor.constraint(equalTo: dateHeader.bottomAnchor, constant: 10),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            stackView.topAnchor.constraint(equalTo: borderView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -5),

            selectedDateLabel.heightAnchor.constraint(equalToConstant: 40),

            calendarButton.widthAnchor.constraint(equalToConstant: 25),
            calendarButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    // MARK: - Method & Action

    @objc private func handleCalendarButton() {
        delegate?.didTapCalendarButton(in: self)
    }
    
    @objc private func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDateLabel.text = dateFormatter.string(from: datePicker.date)
        selectedDateLabel.textColor = .black
    }
}
