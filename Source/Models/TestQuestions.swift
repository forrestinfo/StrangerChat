import Foundation

// DISC测试题库
let DISCQuestions: [TestQuestion] = [
    TestQuestion(id: 1, text: "在团队中，我通常是领导者。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 2, text: "我喜欢与人互动和交流。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 3, text: "我倾向于按部就班地工作。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 4, text: "我注重细节和准确性。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    // ...更多问题
]

// 九型人格测试题库
let EnneagramQuestions: [TestQuestion] = [
    TestQuestion(id: 1, text: "我经常感到需要证明自己的价值。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 2, text: "我倾向于帮助他人解决问题。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 3, text: "我追求成功和成就。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 4, text: "我经常感到孤独和不同。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    // ...更多问题
]

// 十六型人格测试题库
let MBTIQuestions: [TestQuestion] = [
    TestQuestion(id: 1, text: "我喜欢计划和组织活动。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 2, text: "我更喜欢与人互动而不是独自工作。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 3, text: "我更注重事实和细节。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 4, text: "我做决定时更依赖逻辑而不是情感。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    // ...更多问题
]

// 盖洛普优势测试题库
let StrengthsFinderQuestions: [TestQuestion] = [
    TestQuestion(id: 1, text: "我擅长完成任务。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 2, text: "我善于发现他人的潜力。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 3, text: "我喜欢分析问题。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    TestQuestion(id: 4, text: "我善于组织和安排活动。", options: ["非常同意", "同意", "中立", "不同意", "非常不同意"]),
    // ...更多问题
]

// 测试题库管理
struct TestQuestionBank {
    static let shared = TestQuestionBank()
    
    private init() {}
    
    func getQuestions(for testType: PersonalityTestType) -> [TestQuestion] {
        switch testType {
        case .disc: return DISCQuestions
        case .enneagram: return EnneagramQuestions
        case .mbti: return MBTIQuestions
        case .strengthsFinder: return StrengthsFinderQuestions
        }
    }
    
    func getQuestionCount(for testType: PersonalityTestType) -> Int {
        switch testType {
        case .disc: return DISCQuestions.count
        case .enneagram: return EnneagramQuestions.count
        case .mbti: return MBTIQuestions.count
        case .strengthsFinder: return StrengthsFinderQuestions.count
        }
    }
}
