import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var senderId: String
    var content: String
    var timestamp: Date
    var isRead: Bool
}
