import Foundation

protocol CarServicingProtocol {
    func request(completion: @escaping (Result<[CarModel]  , Error>) -> Void)
    func post(cars: CarModel, completion: @escaping (Result<CarModel, Error>) -> Void)
    func update(cars: CarModel, completion: @escaping (Result<CarModel, Error>) -> Void)
}

enum CarService: Request {
    case cars
    
    var endpoint: String {
        return "/cars"
    }
    
    var method: HttpMethod { .get }
    
    var body: Data? { nil }
    
    var headers: [String : String]? { nil }
    var parameters: [String : String]? { nil }
}

enum SaveCar: Request {
    case cars(CarModel)
    
    var endpoint: String {
        return "/cars"
    }
    
    var method: HttpMethod { .post }
    
    var body: Data? {
        switch self {
        case let .cars(cars):
            guard let json = try? JSONEncoder().encode(cars) else { return nil }
            return json
        }
    }
    
    var headers: [String : String]? { ["Content-Type":"application/json"] }
    var parameters: [String : String]? { nil }
}

enum UpdateCar: Request {
    case cars(CarModel)
    
    var endpoint: String {
        switch self {
        case let .cars(cars):
            return "/cars/\(String(describing: cars._id))"
        }
    }
    
    var method: HttpMethod { .put }
    
    var body: Data? {
        switch self {
        case let .cars(cars):
            guard let json = try? JSONEncoder().encode(cars) else { return nil }
            return prepareBody(with: json)
        }
    }
    
    var headers: [String : String]? { nil }
    var parameters: [String : String]? { nil }
}

final class ServiceCar: CarServicingProtocol {
    private let networking: NetworkingProtocol
    private var task: RequestTasking?
    
    init(networking: NetworkingProtocol = Networking()) {
        self.networking = networking
    }
    
    func request(completion: @escaping (Result<[CarModel], Error>) -> Void) {
        task = networking.make(request: CarService.cars, responseType: [CarModel].self, completion: { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
        task?.resume()
    }
    
    func post(cars: CarModel, completion: @escaping (Result<CarModel, Error>) -> Void) {
        task = networking.make(request: SaveCar.cars(cars), responseType: EmptyResponse.self, completion: { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success:
                completion(.success(cars))
            case let .failure(error):
                completion(.failure(error))
            }
        })
        task?.resume()
    }
    
    func update(cars: CarModel, completion: @escaping (Result<CarModel, Error>) -> Void) {
        task = networking.make(request: UpdateCar.cars(cars), responseType: CarModel.self, completion: { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        })
        task?.resume()
    }
}
