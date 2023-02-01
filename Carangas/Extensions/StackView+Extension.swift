import UIKit

extension UIStackView {
    func add(subviews: UIView...) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
}
