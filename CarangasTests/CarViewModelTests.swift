import XCTest
@testable import Carangas

final class CarViewModelTests: XCTestCase {
    private var mockService: MockCarService!
    private var sut: CarViewModel!
    
    override func setUp() {
        super.setUp()
        mockService = MockCarService()
        sut = CarViewModel(model: [], service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchDataSuccessUpdatesModelAndReloads() {
        let cars = [
            CarModel(_id: "1", brand: "VW", gasType: 0, name: "Gol", price: 50000)
        ]
        mockService.requestResult = .success(cars)
        
        let reloadExpectation = expectation(description: "reloadData called")
        sut.reloadData = {
            reloadExpectation.fulfill()
        }
        
        sut.fetchData()
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(sut.count, 1)
        XCTAssertEqual(sut.getIndexPath(IndexPath(row: 0, section: 0)).name, "Gol")
    }
    
    func testFetchDataFailurePropagatesError() {
        mockService.requestResult = .failure(DummyError())
        
        let errorExpectation = expectation(description: "showError called")
        sut.showError = { error in
            XCTAssertTrue(error is DummyError)
            errorExpectation.fulfill()
        }
        
        sut.fetchData()
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDeleteRemovesCarAtIndex() {
        let cars = [
            CarModel(_id: "1", brand: "VW", gasType: 0, name: "Gol", price: 50000),
            CarModel(_id: "2", brand: "Fiat", gasType: 2, name: "Argo", price: 60000)
        ]
        sut = CarViewModel(model: cars, service: mockService)
        
        sut.delete(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.count, 1)
        XCTAssertEqual(sut.getIndexPath(IndexPath(row: 0, section: 0)).name, "Argo")
    }
}

private struct DummyError: Error {}

private final class MockCarService: CarServicingProtocol {
    var requestResult: Result<[CarModel], Error> = .success([])
    var postResult: Result<CarModel, Error> = .success(CarModel())
    var updateResult: Result<CarModel, Error> = .success(CarModel())
    
    func request(completion: @escaping (Result<[CarModel], Error>) -> Void) {
        completion(requestResult)
    }
    
    func post(cars: CarModel, completion: @escaping (Result<CarModel, Error>) -> Void) {
        completion(postResult)
    }
    
    func update(cars: CarModel, completion: @escaping (Result<CarModel, Error>) -> Void) {
        completion(updateResult)
    }
}
