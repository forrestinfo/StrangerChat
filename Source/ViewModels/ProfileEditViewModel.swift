import Foundation

class ProfileEditViewModel: ObservableObject {
    @Published var user: User
    @Published var errorMessage: String = ""
    @Published var showError = false
    
    private let apiClient: APIClient
    
    init(user: User, apiClient: APIClient = .init()) {
        self.user = user
        self.apiClient = apiClient
    }
    
    var isValid: Bool {
        !user.username.isEmpty && user.age >= 18 && user.age <= 100
    }
    
    var interests: String {
        get {
            user.interests.joined(separator: ", ")
        }
        set {
            user.interests = newValue.split(separator: ",").map(String.init)
        }
    }
    
    func uploadImage() {
        // TODO: 实现图片上传功能
        // 可以使用 UIImagePickerController 或者 PhotosUI
    }
    
    func save() {
        guard isValid else {
            errorMessage = "请检查输入信息"
            showError = true
            return
        }
        
        Task {
            do {
                try await apiClient.put(endpoint: "users/\(user.id)", body: user)
                // 保存成功后关闭视图
            } catch {
                errorMessage = "保存失败: \(error.localizedDescription)"
                showError = true
            }
        }
    }
}
