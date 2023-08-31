import UIKit
import Then
import SnapKit

class DatePickerPopupView: UIView {
    
    // MARK: - Properties
    
    private var datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .inline
    }
    
    private lazy var doneButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
    }
    
    private lazy var cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    var onSelectDate: ((Date) -> Void)?
    var onCancel: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        let contentView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemGray5.cgColor
            $0.clipsToBounds = true
        }
        
        contentView.addSubviews(datePicker, doneButton, cancelButton)
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)
            $0.width.equalTo(320)
        }
        
        datePicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }

    // MARK: - Method & Action
    
    @objc private func handleDone() {
        onSelectDate?(datePicker.date)
        removeFromSuperview()
    }
    
    @objc private func handleCancel() {
        onCancel?()
        removeFromSuperview()
    }
}
