import Foundation

protocol CarViewModelProtocol: AnyObject {
    func addCars()
}

final class CarViewModel {
    
    weak var delegate: CarViewModelProtocol?
    
    private let service: CarServicingProtocol
    private var model: [CarModel]
    
    var count: Int { model.count }
    var cars: String = ""
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    
    init(model: [CarModel] = [], service: CarServicingProtocol = ServiceCar()) {
        self.model = model
        self.service = service
    }
    
    func getIndexPath(_ index: IndexPath) -> CarModel {
        model[index.row]
    }
    
    func didAddCars() {
        delegate?.addCars()
    }
    
    func fetchData() {
        service.request { [weak self] result in
            switch result {
            case let .success(cars):
                self?.model = cars
                self?.reloadData?()
            case let .failure(error):
                self?.showError?(error)
            }
        }
    }

    func delete(at index: IndexPath) {
        model.remove(at: index.row)
    }
}
