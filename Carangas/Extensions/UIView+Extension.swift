import UIKit
extension UIView {
    func add(views: UIView...) {
        for views in views {
            addSubview(views)
        }
    }
}
