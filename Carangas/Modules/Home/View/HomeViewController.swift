import UIKit

final class HomeViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.dataSource = self
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.rowHeight = UITableView.automaticDimension
        table.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        return cell
    }
}

extension HomeViewController: ViewConfiguration {
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
        title = "Carangas"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: nil)
        view.backgroundColor = .systemBackground
    }
}

