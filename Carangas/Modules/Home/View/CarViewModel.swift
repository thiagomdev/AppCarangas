import Foundation

protocol CarViewModelProtocol: AnyObject {
    func addCars()
}

final class CarViewModel {
    
    weak var delegate: CarViewModelProtocol?
    
    private let service: CarServicingProtocol
    var model: [CarModel]
    
    var count: Int { model.count }
    var cars: String = ""
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    
    init(model: [CarModel] = [], service: CarServicingProtocol = ServiceCar()) {
        self.model = model
        self.service = service
    }
    
    func didAddCars() {
        delegate?.addCars()
    }
    
    func fetchData(cars: String) {
        service.request(cars: cars) { [weak self] result in
            switch result {
            case let .success(cars):
                self?.model = cars
                self?.reloadData?()
            case let .failure(error):
                self?.showError?(error)
            }
        }
    }
}