import Foundation

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    private let messageService: MessageService
    private let user: User
    private let currentUser: User
    
    init(user: User, currentUser: User, messageService: MessageService = .init()) {
        self.user = user
        self.currentUser = currentUser
        self.messageService = messageService
        loadMessages()
    }
    
    func loadMessages() {
        Task {
            do {
                messages = try await messageService.getMessages(with: user.id)
                    .sorted { $0.timestamp < $1.timestamp }
            } catch {
                print("Error loading messages: \(error)")
            }
        }
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let message = Message(
            id: UUID().uuidString,
            senderId: currentUser.id,
            content: messageText,
            timestamp: Date(),
            isRead: false
        )
        
        Task {
            do {
                try await messageService.sendMessage(message, to: user.id)
                messages.append(message)
                messageText = ""
            } catch {
                print("Error sending message: \(error)")
            }
        }
    }
}
