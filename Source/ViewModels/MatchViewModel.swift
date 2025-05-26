import Foundation

class MatchViewModel: ObservableObject {
    @Published var matches: [(user: User, compatibility: Double)] = []
    @Published var minimumCompatibility: Double = 60
    private let matchService: MatchService
    private let apiClient: APIClient
    private var currentUser: User
    
    init(currentUser: User, apiClient: APIClient = .init()) {
        self.currentUser = currentUser
        self.matchService = MatchService()
        self.apiClient = apiClient
        loadMatches()
    }
    
    func loadMatches() {
        Task {
            do {
                let potentialMatches = try await apiClient.get(endpoint: "users/potential-matches")
                matches = matchService.getBestMatches(currentUser: currentUser, potentialMatches: potentialMatches)
                    .filter { $0.compatibility >= minimumCompatibility }
            } catch {
                print("Error loading matches: \(error)")
            }
        }
    }
    
    func refreshMatches() {
        loadMatches()
    }
    
    func selectMatch(_ user: User) {
        // TODO: 实现匹配详情页面导航
    }
    
    func isFavorite(_ userId: String) -> Bool {
        // TODO: 实现收藏功能
        return false
    }
}
