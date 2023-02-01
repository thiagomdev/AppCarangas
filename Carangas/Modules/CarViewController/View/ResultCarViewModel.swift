import Foundation

protocol ResultCarViewModelProtocol: AnyObject {
    func showDetailCars()
}

final class ResultCarViewModel {
    var model: CarModel
    private let service = ServiceCar()
    var showError: ((Error) -> Void)?
    
    weak var delegate: ResultCarViewModelProtocol?
    
    init(model: CarModel = .init(brand: "", gasType: 0, name: "", price: 0)) {
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
            switch result {
            case let .success(cars):
                self?.model = cars
            case let .failure(error):
                self?.showError?(error)
            }
        }
    }
}
