import Foundation

protocol ResultCarViewModelProtocol: AnyObject {
    func showDetailCars()
}

final class ResultCarViewModel {
    var model: CarModel
    
    weak var delegate: ResultCarViewModelProtocol?
    
    init(model: CarModel = .init(brand: "", gasType: 0, name: "", price: 0)) {
        self.model = model
    }
    
    func showCars() {
        delegate?.showDetailCars()
    }
}
