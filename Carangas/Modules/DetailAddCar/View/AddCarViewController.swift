import UIKit

final class AddCarViewController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var brandTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Marca"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .left
        return textField
    }()
    
    private lazy var carNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nome"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .left
        return textField
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Preço"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .left
        return textField
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Flex", "Álcool", "Gasolina"])
        segmentControl.backgroundColor = .systemTeal
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private lazy var registerCarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cadastrar Carro", for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didRegisterCar), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.style = .large
        activity.tintColor = .systemTeal
        activity.clearsContextBeforeDrawing = true
        activity.autoresizesSubviews = true
        activity.contentMode = .scaleAspectFill
        activity.isUserInteractionEnabled = true
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc
    private func didRegisterCar() {
        activityIndicator.startAnimating()
    }
}

extension AddCarViewController: ViewConfiguration {
    func buildHierarchyView() {
        stackView.add(
            subviews: brandTextField,
            carNameTextField,
            priceTextField,
            segmentControl,
            registerCarButton
        )
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activateConstraints([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 3),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 5)
        ])
    }
    
    func configureUI() {
        title = "Cadastro"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
