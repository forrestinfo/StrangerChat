import Foundation

class AutoMatchViewModel: ObservableObject {
    @Published var isAutoMatching = false
    @Published var matchFrequency: TimeInterval = 60 * 60
    @Published var matchCount: Int = 10
    @Published var matchSuggestions: [MatchSuggestion] = []
    @Published var errorMessage: String = ""
    @Published var showError = false
    
    private let autoMatchService: AutoMatchService
    private let currentUser: User
    
    init(currentUser: User, autoMatchService: AutoMatchService = .shared) {
        self.currentUser = currentUser
        self.autoMatchService = autoMatchService
        loadSettings()
    }
    
    func loadSettings() {
        // 从本地存储加载设置
        // 这里需要实现具体的加载逻辑
    }
    
    func saveSettings() {
        // 保存设置到本地存储
        // 这里需要实现具体的保存逻辑
    }
    
    func toggleAutoMatching() {
        if isAutoMatching {
            // 停止自动匹配
            isAutoMatching = false
        } else {
            // 开始自动匹配
            isAutoMatching = true
            autoMatchService.startAutoMatching(for: currentUser, interval: matchFrequency)
        }
        saveSettings()
    }
    
    func refreshSuggestions() {
        Task {
            do {
                let suggestions = try await autoMatchService.getMatchSuggestions(for: currentUser, count: matchCount)
                
                // 获取每个建议的详细分析
                for suggestion in suggestions {
                    let analysis = autoMatchService.getMatchAnalysis(for: currentUser, suggestion)
                    matchSuggestions.append(
                        MatchSuggestion(
                            user: suggestion,
                            compatibility: analysis.overallScore,
                            analysis: analysis
                        )
                    )
                }
            } catch {
                errorMessage = "获取匹配建议失败: \(error.localizedDescription)"
                showError = true
            }
        }
    }
}

// 匹配建议
struct MatchSuggestion {
    let user: User
    let compatibility: Double
    let analysis: MatchAnalysis
}
