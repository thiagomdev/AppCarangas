import UIKit

final class CarViewController: UIViewController {
    
    private let viewModel: CarViewModel
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.dataSource = self
        table.delegate = self
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.rowHeight = UITableView.automaticDimension
        table.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        table.register(CarTableViewCell.self, forCellReuseIdentifier: CarTableViewCell.identifier)
        return table
    }()
    
    init(viewModel: CarViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didLoadCars(cars: viewModel.cars)
        reloadData()
    }
    
    private func didLoadCars(cars: String) {
        viewModel.fetchData(cars: cars)
    }
    
    private func reloadData() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc
    private func addCarsButton() {
        viewModel.didAddCars()
    }
}

extension CarViewController: CarViewModelProtocol {
    func addCars() {
        let addCarsView = AddCarViewController(viewModel: .init())
        navigationController?.pushViewController(addCarsView, animated: true)
    }
}

extension CarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addCarsView = ResultCarViewController(viewModel: .init())
        addCarsView.viewModel.model = viewModel.model[indexPath.row]
        navigationController?.pushViewController(addCarsView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CarTableViewCell.identifier,
            for: indexPath) as? CarTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.setup(for: .init(carModel: viewModel.model[indexPath.row]))
        return cell
    }
}

extension CarViewController: ViewConfiguration {
    func buildHierarchyView() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activateConstraints([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1)
        ])
    }
    
    func configureUI() {
        viewModel.delegate = self
        title = "Carangas"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addCarsButton))
        view.backgroundColor = .systemBackground
    }
}

