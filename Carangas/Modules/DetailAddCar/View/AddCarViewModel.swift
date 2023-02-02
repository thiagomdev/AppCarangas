import Foundation

final class AddCarViewModel {
    private var carModel: CarModel
    private let service: CarServicingProtocol
//    var cars: String = ""
    var back: (() -> Void)?
    var showError: ((Error) -> Void)?
    var reloadData: (() -> Void)?
    
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
    
    func getCarID() -> String {
        return carModel._id ?? ""
    }
    
    func setName(_ name: String) {
        carModel.name = name
    }
    
    func setBrandName(_ brand: String) {
        carModel.brand = brand
    }
    
    func setGastype(_ gas: Int) {
        carModel.gasType = gas
    }
    
    func setPrice(_ price: String) {
        guard let price = Double(price) else { return }
        carModel.price = price
    }
    
    func goBack() {
        back?()
    }
    
    func save(cars: CarModel) {
        service.post(cars: cars) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(saveCar):
                    self?.carModel = saveCar
                    self?.reloadData?()
                case let .failure(error):
                    self?.showError?(error)
                }
            }
        }
    }
    
    func update(cars: CarModel) {
        service.update(cars: cars) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(model):
                    self?.carModel = model
                    self?.reloadData?()
                case let .failure(error):
                    self?.showError?(error)
                }
            }
        }
    }
    
    func save() {
        if carModel._id == nil {
            save(cars: carModel)
        } else {
            update(cars: carModel)
        }
    }
}
