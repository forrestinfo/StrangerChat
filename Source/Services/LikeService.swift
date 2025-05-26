import Foundation

protocol LikeServiceProtocol {
    func like(user: User) async throws
    func unlike(user: User) async throws
    func getLikes() async throws -> [User]
    func checkMatch(user: User) async throws -> Bool
}

class LikeService: LikeServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func like(user: User) async throws {
        try await apiClient.post(endpoint: "likes/\(user.id)")
        // 检查是否匹配
        try await checkMatch(user: user)
    }
    
    func unlike(user: User) async throws {
        try await apiClient.delete(endpoint: "likes/\(user.id)")
    }
    
    func getLikes() async throws -> [User] {
        return try await apiClient.get(endpoint: "likes")
    }
    
    func checkMatch(user: User) async throws -> Bool {
        let match = try await apiClient.get(endpoint: "matches/\(user.id)")
        if match {
            // 发送匹配通知
            try await apiClient.post(endpoint: "notifications/match")
        }
        return match
    }
}
