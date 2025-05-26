import Foundation

protocol MessageServiceProtocol {
    func sendMessage(_ message: Message, to userId: String) async throws
    func getMessages(with userId: String) async throws -> [Message]
    func markMessageAsRead(_ messageId: String) async throws
    func deleteMessage(_ messageId: String) async throws
}

class MessageService: MessageServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func sendMessage(_ message: Message, to userId: String) async throws {
        try await apiClient.post(endpoint: "messages/\(userId)", body: message)
    }
    
    func getMessages(with userId: String) async throws -> [Message] {
        return try await apiClient.get(endpoint: "messages/\(userId)")
    }
    
    func markMessageAsRead(_ messageId: String) async throws {
        try await apiClient.put(endpoint: "messages/\(messageId)/read")
    }
    
    func deleteMessage(_ messageId: String) async throws {
        try await apiClient.delete(endpoint: "messages/\(messageId)")
    }
}
