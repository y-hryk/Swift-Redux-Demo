import Foundation

enum TheMoviebd {}

protocol TheMoviebdAPIRequestProtocol: APIRequestProtocol {}
extension TheMoviebdAPIRequestProtocol {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }
}

struct TheMoviebdAPIClient {
    static let apiKey = "0a06fbb707cb2165dffcd8d27fd04365"
    
    // MARK: Variables
    private static let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
    // MARK: Method
    // APIの呼び出し
    static func send<T, V>(_ request: T) async throws -> V where T: APIRequestProtocol, V: Codable, T.ResponseType == V {
        
        let url = request.baseURL.appendingPathComponent(request.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: TheMoviebdAPIClient.apiKey)
        ]
        if let parameters = request.parameters {
            for (_, value) in parameters.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.timeoutInterval = TimeInterval(30)
        
        let result = try await URLSession.shared.data(for: urlRequest)
//        print("\n🚀 WebApi Log")
//        print("\(request.method.rawValue.uppercased()) \(request.baseURL)\(request.path)")
//        print("Params: \(String(describing: request.parameters))")
        if let statusCode = (result.1 as? HTTPURLResponse)?.statusCode {
//            print("StatusCode: \(statusCode)")
        }
        do {
            let data = try validateCode(data: result.0, response: result.1)
            if let response = try? JSONSerialization.jsonObject(with: data) {
//                print("Response: \(response)")
            }
            return try decoder.decode(V.self, from: data)
        } catch let error {
            if error is NetworkError {
                if let response = try? JSONSerialization.jsonObject(with: result.0) {
                    print("Error Response: \(response)")
                }
            } else {
                print(error)
            }
            throw error
        }
    }
    
    static func validateCode(data: Data, response: URLResponse) throws -> Data {
        switch (response as? HTTPURLResponse)?.statusCode {
        case .some(let code) where code == 401:
            throw NetworkError.badRequest(code: code, message: "Unauthorized")
        case .some(let code) where code == 404:
            throw NetworkError.badRequest(code: code, message: "Not Found")
        case .some(let code) where (400..<500).contains(code):
            throw NetworkError.badRequest(code: code, message: "bad request")
        case .some(let code) where (200..<300).contains(code):
            return data
        case .some(let code):
            throw NetworkError.server(code: code)
        case .none:
            throw NetworkError.unknown
        }
    }
}
