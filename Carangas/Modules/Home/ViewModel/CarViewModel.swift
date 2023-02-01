import Foundation

protocol CarViewModelProtocol: AnyObject {
    func addCars()
}

final class CarViewModel {
    
    weak var delegate: CarViewModelProtocol?
    
    func didAddCars() {
        delegate?.addCars()
    }
}
