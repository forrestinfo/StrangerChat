import SwiftUI

enum Tab: String {
    case chat
    case discovery
    case profile
}

struct MainTabView: View {
    @StateObject private var viewModel = MainTabViewModel()
    @State private var selectedTab: Tab = .chat
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChatListView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
                .tag(Tab.chat)
            
            DiscoveryView()
                .tabItem {
                    Label("Discovery", systemImage: "person.2.fill")
                }
                .tag(Tab.discovery)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
    }
}
