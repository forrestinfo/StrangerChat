import Foundation

struct PersonalityTestResult: Codable {
    // DISC性格测试结果
    struct DISCResult: Codable {
        let dominance: Double
        let influence: Double
        let steadiness: Double
        let compliance: Double
        let primaryStyle: DISCStyle
        let secondaryStyle: DISCStyle
    }
    
    // 九型人格测试结果
    struct EnneagramResult: Codable {
        let type: EnneagramType
        let wing: EnneagramWing?
        let level: Int
    }
    
    // 十六型人格测试结果
    struct MBTIResult: Codable {
        let type: MBTIType
        let scores: [MBTIScore]
    }
    
    // 盖洛普优势测试结果
    struct StrengthsFinderResult: Codable {
        let topFive: [Strength]
        let fullResults: [Strength]
    }
    
    let disc: DISCResult
    let enneagram: EnneagramResult
    let mbti: MBTIResult
    let strengthsFinder: StrengthsFinderResult
}

// DISC性格类型
enum DISCStyle: String, Codable {
    case dominance = "D"
    case influence = "I"
    case steadiness = "S"
    case compliance = "C"
}

// 九型人格类型
enum EnneagramType: Int, Codable {
    case type1 = 1
    case type2
    case type3
    case type4
    case type5
    case type6
    case type7
    case type8
    case type9
}

// 九型人格翼型
enum EnneagramWing: String, Codable {
    case wing1 = "1w2"
    case wing2 = "2w1"
    case wing3 = "3w4"
    case wing4 = "4w3"
    case wing5 = "5w6"
    case wing6 = "6w5"
    case wing7 = "7w8"
    case wing8 = "8w7"
    case wing9 = "9w1"
}

// 十六型人格类型
enum MBTIType: String, Codable {
    case istj = "ISTJ"
    case isfj = "ISFJ"
    case infj = "INFJ"
    case intj = "INTJ"
    case istp = "ISTP"
    case isfp = "ISFP"
    case infp = "INFP"
    case intp = "INTP"
    case estp = "ESTP"
    case esfp = "ESFP"
    case enfp = "ENFP"
    case entp = "ENTP"
    case estj = "ESTJ"
    case esfj = "ESFJ"
    case enfj = "ENFJ"
    case entj = "ENTJ"
}

// 十六型人格分数
struct MBTIScore: Codable {
    let trait: MBTITrait
    let score: Double
}

enum MBTITrait: String, Codable {
    case introversion = "I"
    case extroversion = "E"
    case sensing = "S"
    case intuition = "N"
    case thinking = "T"
    case feeling = "F"
    case judging = "J"
    case perceiving = "P"
}

// 盖洛普优势
enum Strength: String, Codable {
    case achiever = "Achiever"
    case activator = "Activator"
    case adaptability = "Adaptability"
    case analytical = "Analytical"
    case arranger = "Arranger"
    case belief = "Belief"
    case command = "Command"
    case communication = "Communication"
    case competition = "Competition"
    case connectedness = "Connectedness"
    case consistency = "Consistency"
    case context = "Context"
    case deliberative = "Deliberative"
    case developer = "Developer"
    case discipline = "Discipline"
    case empathy = "Empathy"
    case focus = "Focus"
    case futuristic = "Futuristic"
    case harmony = "Harmony"
    case ideation = "Ideation"
    case inclusion = "Inclusion"
    case individualization = "Individualization"
    case intellection = "Intellection"
    case learner = "Learner"
    case maximizer = "Maximizer"
    case positivity = "Positivity"
    case relator = "Relator"
    case responsibility = "Responsibility"
    case restorative = "Restorative"
    case selfAssurance = "Self-Assurance"
    case significance = "Significance"
    case strategic = "Strategic"
    case woo = "Woo"
}
