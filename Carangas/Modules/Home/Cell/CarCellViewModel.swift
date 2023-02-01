import Foundation

final class CarCellViewModel {
    private var carModel: CarModel
    
    init(carModel: CarModel) {
        self.carModel = carModel
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
}
