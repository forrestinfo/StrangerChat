import Foundation
import CryptoKit

class SecurityService {
    static let shared = SecurityService()
    
    private init() {}
    
    // 数据加密
    func encrypt(_ data: Data) throws -> Data {
        let key = SymmetricKey(size: .bits256)
        return try AES.GCM.seal(data, using: key).combined
    }
    
    // 数据解密
    func decrypt(_ data: Data) throws -> Data {
        let key = SymmetricKey(size: .bits256)
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    // 生成安全的随机数
    func generateRandomBytes(length: Int) -> Data {
        var bytes = [UInt8](repeating: 0, count: length)
        _ = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        return Data(bytes)
    }
    
    // 生成安全的密码
    func generateSecurePassword(length: Int = 12) -> String {
        let passwordCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        let randomBytes = generateRandomBytes(length: length)
        
        return String(
            randomBytes.map { byte in
                passwordCharacters[Int(byte) % passwordCharacters.count]
            }
        )
    }
    
    // 验证密码强度
    func validatePassword(_ password: String) -> PasswordStrength {
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecial = password.rangeOfCharacter(from: .punctuationCharacters) != nil
        let length = password.count
        
        if length < 8 {
            return .weak
        }
        
        let requirements = [
            hasUppercase,
            hasLowercase,
            hasNumber,
            hasSpecial
        ].filter { $0 }.count
        
        switch requirements {
        case 0...1: return .weak
        case 2...3: return .medium
        default: return .strong
        }
    }
    
    // 验证手机号
    func validatePhone(_ phone: String) -> Bool {
        let phoneRegex = "^1[3-9]\d{9}$"
        return phone.range(of: phoneRegex, options: .regularExpression) != nil
    }
    
    // 验证邮箱
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
}

enum PasswordStrength {
    case weak
    case medium
    case strong
}
