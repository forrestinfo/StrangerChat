import Foundation

class MatchService {
    // 星座匹配度权重（基于传统星座配对理论）
    private let zodiacCompatibility: [User.ZodiacSign: [User.ZodiacSign: Double]] = {
        var dict: [User.ZodiacSign: [User.ZodiacSign: Double]] = [:]
        
        // 火象星座（白羊座、狮子座、射手座）
        let fireSigns = [User.ZodiacSign.aries, .leo, .sagittarius]
        // 土象星座（金牛座、处女座、魔羯座）
        let earthSigns = [User.ZodiacSign.taurus, .virgo, .capricorn]
        // 风象星座（双子座、天秤座、水瓶座）
        let airSigns = [User.ZodiacSign.gemini, .libra, .aquarius]
        // 水象星座（巨蟹座、天蝎座、双鱼座）
        let waterSigns = [User.ZodiacSign.cancer, .scorpio, .pisces]
        
        // 同属性星座最佳匹配（80%）
        for signs in [fireSigns, earthSigns, airSigns, waterSigns] {
            for sign in signs {
                dict[sign] = [:]
                for otherSign in signs {
                    if sign != otherSign {
                        dict[sign]?[otherSign] = 0.8
                    }
                }
            }
        }
        
        // 相邻属性星座良好匹配（60%）
        let adjacentPairs: [(User.ZodiacSign, User.ZodiacSign)] = [
            (.aries, .taurus), (.aries, .gemini),
            (.taurus, .cancer), (.cancer, .leo),
            (.leo, .virgo), (.virgo, .libra),
            (.libra, .scorpio), (.scorpio, .sagittarius),
            (.sagittarius, .capricorn), (.capricorn, .aquarius),
            (.aquarius, .pisces), (.pisces, .aries)
        ]
        
        for (sign1, sign2) in adjacentPairs {
            dict[sign1]?[sign2] = 0.6
            dict[sign2]?[sign1] = 0.6
        }
        
        // 相对星座中等匹配（40%）
        for i in 0..<12 {
            let sign1 = User.ZodiacSign.allCases[i]
            let sign2 = User.ZodiacSign.allCases[(i + 6) % 12]
            dict[sign1]?[sign2] = 0.4
            dict[sign2]?[sign1] = 0.4
        }
        
        return dict
    }()
    
    // 生肖匹配度权重（基于中国传统生肖配对理论）
    private let chineseZodiacCompatibility: [User.ChineseZodiac: [User.ChineseZodiac: Double]] = {
        var dict: [User.ChineseZodiac: [User.ChineseZodiac: Double]] = [:]
        
        // 三合局（最佳匹配）
        let trineGroups: [(User.ChineseZodiac, User.ChineseZodiac, User.ChineseZodiac)] = [
            (.rat, .dragon, .monkey),
            (.ox, .snake, .rooster),
            (.tiger, .horse, .dog),
            (.rabbit, .sheep, .pig)
        ]
        
        // 六合（良好匹配）
        let harmoniousPairs: [(User.ChineseZodiac, User.ChineseZodiac)] = [
            (.rat, .ox), (.rat, .monkey), (.rat, .dragon),
            (.ox, .rat), (.ox, .rooster), (.ox, .snake),
            (.tiger, .dog), (.tiger, .horse), (.tiger, .rabbit),
            (.rabbit, .dog), (.rabbit, .sheep), (.rabbit, .pig),
            (.dragon, .rat), (.dragon, .monkey), (.dragon, .rooster),
            (.snake, .ox), (.snake, .rooster), (.snake, .dragon),
            (.horse, .tiger), (.horse, .dog), (.horse, .rabbit),
            (.sheep, .rabbit), (.sheep, .pig), (.sheep, .dog),
            (.monkey, .rat), (.monkey, .dragon), (.monkey, .rooster),
            (.rooster, .ox), (.rooster, .snake), (.rooster, .dragon),
            (.dog, .tiger), (.dog, .horse), (.dog, .rabbit),
            (.pig, .rabbit), (.pig, .sheep), (.pig, .dog)
        ]
        
        // 冲克（一般匹配）
        let conflictingPairs: [(User.ChineseZodiac, User.ChineseZodiac)] = [
            (.rat, .horse), (.ox, .sheep), (.tiger, .monkey), (.rabbit, .rooster),
            (.dragon, .dog), (.snake, .pig), (.horse, .rat), (.sheep, .ox),
            (.monkey, .tiger), (.rooster, .rabbit), (.dog, .dragon), (.pig, .snake)
        ]
        
        // 初始化所有生肖的匹配度
        User.ChineseZodiac.allCases.forEach { sign1 in
            dict[sign1] = [:]
            User.ChineseZodiac.allCases.forEach { sign2 in
                // 同生肖最佳匹配
                if sign1 == sign2 {
                    dict[sign1]?[sign2] = 0.8
                }
                // 三合局最佳匹配
                else if trineGroups.contains(where: { $0.contains(sign1) && $0.contains(sign2) }) {
                    dict[sign1]?[sign2] = 0.8
                }
                // 六合良好匹配
                else if harmoniousPairs.contains(where: { $0 == (sign1, sign2) || $0 == (sign2, sign1) }) {
                    dict[sign1]?[sign2] = 0.7
                }
                // 冲克一般匹配
                else if conflictingPairs.contains(where: { $0 == (sign1, sign2) || $0 == (sign2, sign1) }) {
                    dict[sign1]?[sign2] = 0.4
                }
                // 其他情况中等匹配
                else {
                    dict[sign1]?[sign2] = 0.6
                }
            }
        }
        
        return dict
    }()
    
    // 血型匹配度权重（基于传统血型配对理论）
    private let bloodCompatibility: [User.BloodType: [User.BloodType: Double]] = {
        var dict: [User.BloodType: [User.BloodType: Double]] = [:]
        
        // A型血
        dict[.a] = [.a: 0.8, .ab: 0.7, .o: 0.6]
        // B型血
        dict[.b] = [.b: 0.8, .ab: 0.7, .o: 0.6]
        // AB型血
        dict[.ab] = [.ab: 0.8, .a: 0.7, .b: 0.7, .o: 0.5]
        // O型血
        dict[.o] = [.o: 0.8, .a: 0.6, .b: 0.6, .ab: 0.5]
        
        return dict
    }()
    
    /// 计算两个用户之间的匹配度
    /// - Parameters:
    ///   - user1: 第一个用户
    ///   - user2: 第二个用户
    /// - Returns: 匹配度分数（0-100）
    func calculateCompatibility(user1: User, user2: User) -> Double {
        // 星座匹配度
        let zodiacScore = zodiacCompatibility[user1.zodiacSign]?[user2.zodiacSign] ?? 0.5
        // 血型匹配度
        let bloodScore = bloodCompatibility[user1.bloodType]?[user2.bloodType] ?? 0.5
        // 生肖匹配度
        let chineseZodiacScore = chineseZodiacCompatibility[user1.chineseZodiac]?[user2.chineseZodiac] ?? 0.5
        
        // 性格匹配度
        let personalityScore = personalityService.calculatePersonalityCompatibility(
            user1.personalityResults,
            user2.personalityResults
        )
        
        // 综合匹配度（星座占25%，血型占20%，生肖占20%，性格占35%）
        return (zodiacScore * 0.25 + bloodScore * 0.2 + chineseZodiacScore * 0.2 + personalityScore * 0.35) * 100
    }
    
    /// 获取与特定用户最匹配的用户列表
    /// - Parameters:
    ///   - currentUser: 当前用户
    ///   - potentialMatches: 潜在匹配的用户列表
    /// - Returns: 按匹配度排序的用户列表
    func getBestMatches(currentUser: User, potentialMatches: [User]) -> [(User, Double)] {
        return potentialMatches
            .map { (user: $0, score: calculateCompatibility(user1: currentUser, user2: $0)) }
            .sorted { $0.score > $1.score }
    }
}
