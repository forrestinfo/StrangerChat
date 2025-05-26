import Foundation

class PersonalityTestViewModel: ObservableObject {
    @Published var currentTest: PersonalityTestType = .disc
    @Published var errorMessage: String = ""
    @Published var showError = false
    
    private let personalityService: PersonalityService
    
    // DISC测试数据
    @Published var discQuestions: [TestQuestion] = []
    @Published var discAnswers: [Int] = Array(repeating: 0, count: 20)
    
    // 九型人格测试数据
    @Published var enneagramQuestions: [TestQuestion] = []
    @Published var enneagramAnswers: [Int] = Array(repeating: 0, count: 30)
    
    // 十六型人格测试数据
    @Published var mbtiQuestions: [TestQuestion] = []
    @Published var mbtiAnswers: [Int] = Array(repeating: 0, count: 50)
    
    // 盖洛普优势测试数据
    @Published var strengthsFinderQuestions: [TestQuestion] = []
    @Published var strengthsFinderAnswers: [Int] = Array(repeating: 0, count: 60)
    
    init(personalityService: PersonalityService = .init()) {
        self.personalityService = personalityService
        loadQuestions()
    }
    
    private func loadQuestions() {
        // DISC问题
        discQuestions = [
            TestQuestion(id: 1, text: "在团队中，我通常是领导者。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
            // ...更多问题
        ]
        
        // 九型人格问题
        enneagramQuestions = [
            TestQuestion(id: 1, text: "我经常感到需要证明自己的价值。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
            // ...更多问题
        ]
        
        // 十六型人格问题
        mbtiQuestions = [
            TestQuestion(id: 1, text: "我喜欢计划和组织活动。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
            // ...更多问题
        ]
        
        // 盖洛普优势问题
        strengthsFinderQuestions = [
            TestQuestion(id: 1, text: "我擅长完成任务。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
            // ...更多问题
        ]
    }
    
    var canSubmit: Bool {
        switch currentTest {
        case .disc: return !discAnswers.contains(0)
        case .enneagram: return !enneagramAnswers.contains(0)
        case .mbti: return !mbtiAnswers.contains(0)
        case .strengthsFinder: return !strengthsFinderAnswers.contains(0)
        }
    }
    
    func submitTest() {
        Task {
            do {
                switch currentTest {
                case .disc:
                    try await personalityService.takeDISCTest(answers: discAnswers)
                case .enneagram:
                    try await personalityService.takeEnneagramTest(answers: enneagramAnswers)
                case .mbti:
                    try await personalityService.takeMBTITest(answers: mbtiAnswers)
                case .strengthsFinder:
                    try await personalityService.takeStrengthsFinderTest(answers: strengthsFinderAnswers)
                }
            } catch {
                errorMessage = "提交失败: \(error.localizedDescription)"
                showError = true
            }
        }
    }
}
