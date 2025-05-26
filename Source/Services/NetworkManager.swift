import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private let session: URLSession
    private let baseURL = "https://api.strangerchat.com"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // GET请求
    func get<T: Decodable>(endpoint: String, parameters: [String: String] = [:]) async throws -> T {
        var components = URLComponents(string: baseURL + endpoint)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let (data, response) = try await session.data(from: components.url!)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // POST请求
    func post<T: Encodable, U: Decodable>(endpoint: String, body: T) async throws -> U {
        var request = URLRequest(url: URL(string: baseURL + endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(U.self, from: data)
    }
    
    // PUT请求
    func put<T: Encodable>(endpoint: String, body: T) async throws {
        var request = URLRequest(url: URL(string: baseURL + endpoint)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
    }
    
    // DELETE请求
    func delete(endpoint: String) async throws {
        var request = URLRequest(url: URL(string: baseURL + endpoint)!)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
    }
}

enum NetworkError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case encodingError
    case networkError
}
