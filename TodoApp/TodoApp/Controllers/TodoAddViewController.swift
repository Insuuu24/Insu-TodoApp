//
//  TodoAddViewController.swift
//  TodoApp
//
//  Created by Insu on 2023/08/06.
//

import UIKit

class TodoAddViewController: UIViewController {

    // MARK: - Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Todo 추가"
        
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Navigation Bar
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    
    
    
    // MARK: - Setup Layout
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ColorCell.self, forCellReuseIdentifier: "ColorCell")
        tableView.register(TodoWriteCell.self, forCellReuseIdentifier: "TodoWriteCell")
        tableView.register(DateCell.self, forCellReuseIdentifier: "DateCell")
        tableView.register(SaveButtonCell.self, forCellReuseIdentifier: "SaveButtonCell")
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none

        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    

    // MARK: - Method & Action
    

    
    
    
    
    
    

    
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoWriteCell", for: indexPath) as! TodoWriteCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaveButtonCell", for: indexPath) as! SaveButtonCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 셀 선택 비활성화
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }


    
}

// MARK: - DateCell DatePicker Pop-up

extension TodoAddViewController: DateCellDelegate {
    func didTapCalendarButton(in cell: DateCell) {
        let datePickerPopup = DatePickerPopupView(frame: self.view.bounds)
        datePickerPopup.onSelectDate = { selectedDate in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            cell.selectedDateLabel.text = dateFormatter.string(from: selectedDate)
            cell.selectedDateLabel.textColor = .black
        }
        
        //datePickerPopup.onCancel = { }
        
        datePickerPopup.alpha = 0
        self.view.addSubview(datePickerPopup)
        
        // 애니메이션을 통해 투명도를 1로 변경합니다.
        UIView.animate(withDuration: 0.2) {
            datePickerPopup.alpha = 1
        }
    }
}



