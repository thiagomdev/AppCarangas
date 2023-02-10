import Foundation

protocol ResultCarViewModelProtocol: AnyObject {
    func showDetailCars()
}

final class ResultCarViewModel {
    var model: CarModel
    private let service = ServiceCar()
    var showError: ((Error) -> Void)?
    var reloadData: (() -> Void)?
    
    weak var delegate: ResultCarViewModelProtocol?
    
    init(model: CarModel) {
        self.model = model
    }
    
    func showCars() {
        delegate?.showDetailCars()
    }
    
    func brandName() -> String {
        return model.brand
    }
    
    func gasType() -> String {
        return model.gas
    }
    
    func price() -> String {
        return "R$ \(model.price)"
    }
    
    func update(cars: CarModel) {
        service.update(cars: cars) { [weak self] result in
            DispatchQueue.main.async {
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
    
    func updatedCar() {
        if model._id == nil {
            update(cars: model)
        }
    }
}
