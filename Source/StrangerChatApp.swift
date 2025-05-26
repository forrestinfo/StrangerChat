import SwiftUI

@main
struct StrangerChatApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

class AppState: ObservableObject {
    @Published var isAuthenticated = false
    
    func login() {
        isAuthenticated = true
    }
    
    func logout() {
        isAuthenticated = false
    }
}
