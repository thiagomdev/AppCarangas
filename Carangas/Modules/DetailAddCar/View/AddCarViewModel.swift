import Foundation

final class AddCarViewModel {
    var carModel: CarModel
    private let service: CarServicingProtocol
    var cars: String = ""
    var showError: ((Error) -> Void)?
    
    init(carModel: CarModel = .init(), service: CarServicingProtocol = ServiceCar()) {
        self.carModel = carModel
        self.service = service
    }
    
    func carName() -> String {
        return carModel.name
    }
    
    func brandCar() -> String {
        return carModel.brand
    }
    
    func gasType() -> Int {
        return carModel.gasType
    }
    
    func priceCar() -> Double {
        return carModel.price
    }
    
    func save(cars: CarModel) {
        service.post(cars: cars) { [weak self] result in
            switch result {
            case let .success(cars):
                self?.carModel = cars
            case let .failure(error):
                self?.showError?(error)
            }
        }
    }
}
