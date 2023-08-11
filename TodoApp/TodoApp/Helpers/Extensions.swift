

import UIKit

//MARK: - 뷰

extension UIView {
    
    
    
    // 한 번에 여러 객체 addSubView하기
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }

}
