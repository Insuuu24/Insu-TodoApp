import UIKit
import Then
import SnapKit

class TodoListCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let categoryBadge = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.backgroundColor = UIColor(red: 0.34, green: 0.37, blue: 0.49, alpha: 1.00)
        $0.textColor = .white
        $0.layer.cornerRadius = 11
        $0.clipsToBounds = true
    }
    
    private let todoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .lightGray
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
        $0.distribution = .fill
    }
    
    private let buttonImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - Helpers

    private func setupLayout() {
        contentView.addSubviews(stackView, categoryBadge, buttonImageView)
        stackView.addArrangedSubviews(todoLabel, dateLabel)
        
        categoryBadge.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.trailing.equalTo(contentView).offset(-50)
            $0.width.equalTo(70)
            $0.height.equalTo(22)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(15)
            $0.trailing.equalTo(categoryBadge.snp.leading).offset(-10)
            $0.top.equalTo(contentView).offset(10)
            $0.bottom.equalTo(contentView).offset(-10)
        }
        
        buttonImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.width.height.equalTo(20)
        }
    }
    
    func applyStrikeThrough() {
        guard let currentText = todoLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: currentText)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        todoLabel.attributedText = attributedString
    }

    // MARK: - Configure
    
    func configure(with item: TodoData) {
        categoryBadge.text = item.category
        todoLabel.text = item.content
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = formatter.string(from: item.date)
    }
}
