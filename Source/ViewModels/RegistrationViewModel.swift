import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var age: Int = 18
    @Published var gender: User.Gender = .other
    @Published var zodiacSign: User.ZodiacSign = .aries
    @Published var bloodType: User.BloodType = .a
    @Published var bio: String = ""
    @Published var interests: String = ""
    @Published var errorMessage: String = ""
    @Published var showError = false
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .init()) {
        self.apiClient = apiClient
    }
    
    var isValid: Bool {
        !username.isEmpty && age >= 18 && age <= 100
    }
    
    func register() {
        guard isValid else {
            errorMessage = "请填写完整信息"
            showError = true
            return
        }
        
        let user = User(
            id: UUID().uuidString,
            username: username,
            age: age,
            gender: gender,
            zodiacSign: zodiacSign,
            bloodType: bloodType,
            interests: interests.split(separator: ",").map(String.init),
            bio: bio,
            profileImageURL: nil,
            lastActive: Date()
        )
        
        Task {
            do {
                try await apiClient.post(endpoint: "users", body: user)
                // 注册成功后跳转到主界面
            } catch {
                errorMessage = "注册失败: \(error.localizedDescription)"
                showError = true
            }
        }
    }
}
