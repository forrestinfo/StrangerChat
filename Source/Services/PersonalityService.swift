import Foundation

class PersonalityService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    // DISC性格测试
    func takeDISCTest(answers: [Int]) async throws -> DISCResult {
        let result = try await apiClient.post(endpoint: "personality/disc", body: answers)
        return result
    }
    
    // 九型人格测试
    func takeEnneagramTest(answers: [Int]) async throws -> EnneagramResult {
        let result = try await apiClient.post(endpoint: "personality/enneagram", body: answers)
        return result
    }
    
    // 十六型人格测试
    func takeMBTITest(answers: [Int]) async throws -> MBTIResult {
        let result = try await apiClient.post(endpoint: "personality/mbti", body: answers)
        return result
    }
    
    // 盖洛普优势测试
    func takeStrengthsFinderTest(answers: [Int]) async throws -> StrengthsFinderResult {
        let result = try await apiClient.post(endpoint: "personality/strengthsfinder", body: answers)
        return result
    }
    
    // 获取用户性格测试结果
    func getPersonalityResults(userId: String) async throws -> PersonalityTestResult {
        let result = try await apiClient.get(endpoint: "users/\(userId)/personality")
        return result
    }
    
    // 计算性格匹配度
    func calculatePersonalityCompatibility(user1: PersonalityTestResult, user2: PersonalityTestResult) -> Double {
        // DISC性格匹配度
        let discScore = calculateDISCCompatibility(user1.disc, user2.disc)
        // 九型人格匹配度
        let enneagramScore = calculateEnneagramCompatibility(user1.enneagram, user2.enneagram)
        // 十六型人格匹配度
        let mbtiScore = calculateMBTICompatibility(user1.mbti, user2.mbti)
        // 盖洛普优势匹配度
        let strengthsScore = calculateStrengthsFinderCompatibility(user1.strengthsFinder, user2.strengthsFinder)
        
        // 综合匹配度（每个测试占25%权重）
        return (discScore + enneagramScore + mbtiScore + strengthsScore) / 4
    }
    
    private func calculateDISCCompatibility(_ disc1: DISCResult, _ disc2: DISCResult) -> Double {
        // 计算主要风格的相似度
        let styleScore = disc1.primaryStyle == disc2.primaryStyle ? 0.8 : 0.5
        // 计算次要风格的相似度
        let secondaryScore = disc1.secondaryStyle == disc2.secondaryStyle ? 0.3 : 0.1
        // 综合分数
        return styleScore + secondaryScore
    }
    
    private func calculateEnneagramCompatibility(_ enneagram1: EnneagramResult, _ enneagram2: EnneagramResult) -> Double {
        // 相同类型最佳匹配
        if enneagram1.type == enneagram2.type {
            return 0.8
        }
        // 相邻类型良好匹配
        let adjacentTypes: [(EnneagramType, EnneagramType)] = [
            (.type1, .type2), (.type2, .type3), (.type3, .type4),
            (.type4, .type5), (.type5, .type6), (.type6, .type7),
            (.type7, .type8), (.type8, .type9), (.type9, .type1)
        ]
        if adjacentTypes.contains(where: { $0 == (enneagram1.type, enneagram2.type) || $0 == (enneagram2.type, enneagram1.type) }) {
            return 0.6
        }
        // 其他情况中等匹配
        return 0.4
    }
    
    private func calculateMBTICompatibility(_ mbti1: MBTIResult, _ mbti2: MBTIResult) -> Double {
        // 相同类型最佳匹配
        if mbti1.type == mbti2.type {
            return 0.8
        }
        // 相邻类型良好匹配
        let adjacentTypes: [(MBTIType, MBTIType)] = [
            (.istj, .isfj), (.isfj, .infj), (.infj, .intj),
            (.istp, .isfp), (.isfp, .infp), (.infp, .intp),
            (.estp, .esfp), (.esfp, .enfp), (.enfp, .entp),
            (.estj, .esfj), (.esfj, .enfj), (.enfj, .entj)
        ]
        if adjacentTypes.contains(where: { $0 == (mbti1.type, mbti2.type) || $0 == (mbti2.type, mbti1.type) }) {
            return 0.6
        }
        // 其他情况中等匹配
        return 0.4
    }
    
    private func calculateStrengthsFinderCompatibility(_ strengths1: StrengthsFinderResult, _ strengths2: StrengthsFinderResult) -> Double {
        // 计算共同优势的数量
        let commonStrengths = Set(strengths1.topFive).intersection(Set(strengths2.topFive))
        // 根据共同优势数量计算匹配度
        switch commonStrengths.count {
        case 5: return 0.9
        case 4: return 0.8
        case 3: return 0.7
        case 2: return 0.6
        case 1: return 0.5
        default: return 0.3
        }
    }
}
