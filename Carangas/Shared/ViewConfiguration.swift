import Foundation

protocol ViewConfiguration: AnyObject {
    func buildHierarchyView()
    func setupConstraints()
    func configureUI()
    func setup()
}

extension ViewConfiguration {
    func setup() {
        buildHierarchyView()
        setupConstraints()
        configureUI()
    }
}
