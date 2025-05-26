import Foundation

class APIClient {
    private let baseURL = "https://api.strangerchat.com"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func post<T: Encodable>(endpoint: String, body: T) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        _ = try await session.data(for: request)
    }
    
    func put(endpoint: String) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        _ = try await session.data(for: request)
    }
}

enum APIError: Error {
    case invalidURL
    case networkError
    case decodingError
}
