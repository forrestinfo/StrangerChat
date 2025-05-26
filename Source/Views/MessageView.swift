import SwiftUI

struct MessageView: View {
    @StateObject private var viewModel: MessageViewModel
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: MessageViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollView in
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                    .onChange(of: viewModel.messages) { _ in
                        withAnimation {
                            scrollView.scrollTo(viewModel.messages.last?.id)
                        }
                    }
                }
            }
            
            HStack {
                TextField("发送消息...", text: $viewModel.messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: viewModel.sendMessage) {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(viewModel.messageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle(viewModel.user.username)
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.senderId == "currentUserId" {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
