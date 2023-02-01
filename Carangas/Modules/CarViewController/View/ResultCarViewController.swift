import UIKit

final class ResultCarViewController: UIViewController {
    
    private let viewModel: ResultCarViewModel
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 6
        return stack
    }()

    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.text = "Marca"
        label.textColor = .systemTeal
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var gasTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Combustível"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Valor"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    init(viewModel: ResultCarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc
    private func editButtonTapped() {
        viewModel.showCars()
    }
}

extension ResultCarViewController: ResultCarViewModelProtocol {
    func showDetailCars() {
        let detailCars = AddCarViewController()
        navigationController?.pushViewController(detailCars, animated: true)
    }
}

extension ResultCarViewController: ViewConfiguration {
    func buildHierarchyView() {
        stackView.add(subviews: brandLabel, gasTypeLabel, priceLabel)
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activateConstraints([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 3)
        ])
    }
    
    func configureUI() {
        viewModel.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.title = brandLabel.text ?? ""
        view.backgroundColor = .systemBackground
    }
}
