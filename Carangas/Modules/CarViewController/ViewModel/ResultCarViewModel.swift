import Foundation

protocol ResultCarViewModelProtocol: AnyObject {
    func showDetailCars()
}

final class ResultCarViewModel {
    weak var delegate: ResultCarViewModelProtocol?
    
    func showCars() {
        delegate?.showDetailCars()
    }
}
