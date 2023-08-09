

import UIKit

class TodoListCell: UITableViewCell {
    
    // MARK: - Properties
    
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var todoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
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
        contentView.addSubview(stackView)
        contentView.addSubview(colorView)
        contentView.addSubview(buttonImageView)
        
        stackView.addArrangedSubview(todoLabel)
        stackView.addArrangedSubview(dateLabel)

        NSLayoutConstraint.activate([
            
            colorView.centerYAnchor.constraint(equalTo: todoLabel.centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            colorView.widthAnchor.constraint(equalToConstant: 10),
            colorView.heightAnchor.constraint(equalToConstant: 10),

            stackView.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: buttonImageView.leadingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            buttonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            buttonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonImageView.widthAnchor.constraint(equalToConstant: 20),
            buttonImageView.heightAnchor.constraint(equalToConstant: 20)
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

