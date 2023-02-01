import Foundation

protocol Request {
    var baseURL: String { get }
    var endpoint: String { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var method: HttpMethod { get }
}

protocol RequestTasking {
    var request: Request { get }
    func resume()
    func cancel()
}

public func prepareBody<T: Encodable>(with payload: T, strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> Data? {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    jsonEncoder.keyEncodingStrategy = strategy

    do {
        return try jsonEncoder.encode(payload)
    } catch {
        print("Failure to prepare card payload. \(error)")
        return nil
    }
}

extension Request {
    
    var baseURL: String { "https://carangas.herokuapp.com" }
    
    var url: String {
        switch self.method {
        case .get:
            var components = URLComponents()
            let params = parameters ?? [:]
            var queryItems: [URLQueryItem] = []
            
            for (key, value) in params {
                queryItems.append(URLQueryItem(
                    name: key,
                    value: value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                ))
            }
            
            components.queryItems = queryItems
            return baseURL + endpoint + components.path
            
        case .post:
            return baseURL + endpoint
        case .put:
            return baseURL + endpoint
        case .delete:
            return baseURL + endpoint
        }
    }
}

final class Task<T: Decodable>: RequestTasking {
    let request: Request
    
    private let completion: ((Result<T, Error>) -> Void)?
    private var task: URLSessionDataTask?
    
    init(request: Request, completion: ((Result<T, Error>) -> Void)?) {
        self.request = request
        self.completion = completion
    }
    
    func resume() {
        guard let url = URL(string: request.url) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.request.headers
        request.httpMethod = self.request.method.rawValue
        request.httpBody = self.request.body
        
        task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if (200..<300).contains(httpResponse.statusCode), let data = data {
                do {
                    
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    self?.completion?(.success(decoded))
                    
                } catch let error {
                    self?.completion?(.failure(error))
                }
            }
        })
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}

