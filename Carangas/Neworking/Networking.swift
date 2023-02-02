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

enum NetworkError: Error {
    case responseError(Data?, Int)
}

struct EmptyResponse: Decodable {
    init() {
        
    }
}

final class Task<T: Decodable>: RequestTasking {
    let request: Request
    
    private let completion: ((Result<T, Error>) -> Void)?
    private var task: URLSessionDataTask?
    private let responseType: T.Type
    
    init(request: Request, completion: ((Result<T, Error>) -> Void)?, responseType: T.Type) {
        self.request = request
        self.completion = completion
        self.responseType = responseType
    }
    
    func resume() {
        guard let url = URL(string: request.url) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.request.headers
        print("DEBUG: Headers -> \(self.request.headers ?? [:])")
        
        request.httpMethod = self.request.method.rawValue
        print("DEBUG: Method -> \(self.request.method.rawValue)")
        
        request.httpBody = self.request.body
        print("DEBUG: Body -> \(self.request.body ?? Data())")
        
        task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            
            if let data = data {
                let text = String(data: data, encoding: .utf8) ?? ""
                print("DEBUG: Text -> \(text)")
                if let json = try? JSONSerialization.jsonObject(with: data),
                   let printData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let text = String(data: printData, encoding: .utf8)  {
                    print("DEBUG: Text -> \(text)")
                }
            }
            
            if let error = error {
                self?.completion?(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("DEBUD: Status code -> \(httpResponse.statusCode)")
            
            if (200..<300).contains(httpResponse.statusCode), let data = data {
                if self?.responseType is EmptyResponse.Type, let decoded = EmptyResponse() as? T {
                    self?.completion?(.success(decoded))
                } else {
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        self?.completion?(.success(decoded))
                        
                    } catch let error {
                        self?.completion?(.failure(error))
                    }
                }
            } else {
                self?.completion?(.failure(NetworkError.responseError(data, httpResponse.statusCode)))
            }
        })
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}

