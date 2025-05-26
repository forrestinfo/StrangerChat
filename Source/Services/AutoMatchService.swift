import Foundation

class AutoMatchService {
    static let shared = AutoMatchService()
    
    private let matchService: MatchService
    private let notificationService: NotificationService
    private let dataStore: DataStore
    
    private init() {
        matchService = MatchService()
        notificationService = NotificationService.shared
        dataStore = DataStore.shared
    }
    
    // 开始自动匹配
    func startAutoMatching(for user: User, interval: TimeInterval = 60 * 60) {
        // 每小时检查一次新匹配
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.checkForNewMatches(for: user)
        }
        
        // 立即检查一次
        checkForNewMatches(for: user)
    }
    
    // 检查新匹配
    private func checkForNewMatches(for user: User) {
        Task {
            do {
                // 获取所有潜在匹配
                let potentialMatches = try await NetworkManager.shared.get(
                    endpoint: "users/potential-matches",
                    parameters: ["userId": user.id]
                )
                
                // 计算匹配度
                let matches = matchService.getBestMatches(currentUser: user, potentialMatches: potentialMatches)
                
                // 获取之前的匹配历史
                let matchHistory = dataStore.getMatchHistory()
                
                // 找到新的匹配
                let newMatches = matches.filter { match in
                    !matchHistory.contains { $0.userId == match.user.id }
                }
                
                // 保存新匹配
                for match in newMatches {
                    dataStore.saveMatchHistory(
                        user: match.user,
                        compatibility: match.compatibility,
                        zodiacScore: matchService.getZodiacScore(user, match.user),
                        chineseZodiacScore: matchService.getChineseZodiacScore(user, match.user),
                        bloodScore: matchService.getBloodScore(user, match.user),
                        personalityScore: matchService.getPersonalityScore(user, match.user)
                    )
                    
                    // 发送匹配通知
                    notificationService.sendMatchNotification(
                        user: match.user,
                        compatibility: match.compatibility
                    )
                }
            } catch {
                print("Error checking for new matches: \(error)")
            }
        }
    }
    
    // 获取匹配建议
    func getMatchSuggestions(for user: User, count: Int = 10) -> [User] {
        // 获取匹配历史
        let matchHistory = dataStore.getMatchHistory()
        
        // 按匹配度排序
        let sortedHistory = matchHistory.sorted { $0.compatibility > $1.compatibility }
        
        // 获取前N个匹配
        return sortedHistory.prefix(count).map { $0.userId }
    }
    
    // 获取匹配分析
    func getMatchAnalysis(for user1: User, user2: User) -> MatchAnalysis {
        let zodiacScore = matchService.getZodiacScore(user1, user2)
        let chineseZodiacScore = matchService.getChineseZodiacScore(user1, user2)
        let bloodScore = matchService.getBloodScore(user1, user2)
        let personalityScore = matchService.getPersonalityScore(user1, user2)
        
        return MatchAnalysis(
            overallScore: (zodiacScore * 0.25 + chineseZodiacScore * 0.2 + bloodScore * 0.2 + personalityScore * 0.35) * 100,
            zodiacScore: zodiacScore * 100,
            chineseZodiacScore: chineseZodiacScore * 100,
            bloodScore: bloodScore * 100,
            personalityScore: personalityScore * 100
        )
    }
}

// 匹配分析结果
struct MatchAnalysis {
    let overallScore: Double
    let zodiacScore: Double
    let chineseZodiacScore: Double
    let bloodScore: Double
    let personalityScore: Double
    
    var compatibilityLevel: String {
        switch overallScore {
        case 90...100: return "极佳匹配"
        case 75...89: return "非常匹配"
        case 60...74: return "良好匹配"
        case 40...59: return "一般匹配"
        default: return "匹配度较低"
        }
    }
    
    var compatibilityColor: Color {
        switch overallScore {
        case 90...100: return .green
        case 75...89: return .blue
        case 60...74: return .yellow
        case 40...59: return .orange
        default: return .red
        }
    }
}
