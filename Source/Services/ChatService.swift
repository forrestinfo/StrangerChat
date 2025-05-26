import Foundation

protocol ChatServiceProtocol {
    func sendMessage(_ message: Message, to userId: String) async throws
    func getMessages(with userId: String) async throws -> [Message]
    func markMessageAsRead(_ messageId: String) async throws
}

class ChatService: ChatServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func sendMessage(_ message: Message, to userId: String) async throws {
        try await apiClient.post(endpoint: "messages", body: message)
    }
    
    func getMessages(with userId: String) async throws -> [Message] {
        return try await apiClient.get(endpoint: "messages/\(userId)")
    }
    
    func markMessageAsRead(_ messageId: String) async throws {
        try await apiClient.put(endpoint: "messages/\(messageId)/read")
    }
}
