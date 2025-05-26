import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var age: Int
    var gender: Gender
    var zodiacSign: ZodiacSign
    var bloodType: BloodType
    var interests: [String]
    var bio: String
    var profileImageURL: String?
    var lastActive: Date
    var balance: Double
    var premium: Bool
    
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
    
    enum ZodiacSign: String, Codable {
        case aries = "Aries"
        case taurus = "Taurus"
        case gemini = "Gemini"
        case cancer = "Cancer"
        case leo = "Leo"
        case virgo = "Virgo"
        case libra = "Libra"
        case scorpio = "Scorpio"
        case sagittarius = "Sagittarius"
        case capricorn = "Capricorn"
        case aquarius = "Aquarius"
        case pisces = "Pisces"
    }
    
    enum BloodType: String, Codable {
        case a = "A"
        case b = "B"
        case ab = "AB"
        case o = "O"
    }
    
    enum ChineseZodiac: String, Codable {
        case rat = "Rat"
        case ox = "Ox"
        case tiger = "Tiger"
        case rabbit = "Rabbit"
        case dragon = "Dragon"
        case snake = "Snake"
        case horse = "Horse"
        case goat = "Goat"
        case monkey = "Monkey"
        case rooster = "Rooster"
        case dog = "Dog"
        case pig = "Pig"
    }
    
    var chineseZodiac: ChineseZodiac {
        let chineseZodiacs = [ChineseZodiac.rat, .ox, .tiger, .rabbit, .dragon, .snake, .horse, .goat, .monkey, .rooster, .dog, .pig]
        let birthYear = Calendar.current.component(.year, from: Date()) - age
        return chineseZodiacs[(birthYear - 1900) % 12]
    }
}
