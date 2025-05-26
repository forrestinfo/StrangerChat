import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: AppError?
    @Published var showOnboarding = true
    
    // 用户认证状态
    func login() {
        isAuthenticated = true
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
    }
    
    // 错误处理
    func handleError(_ error: Error) {
        self.error = AppError(error: error)
    }
    
    func clearError() {
        error = nil
    }
    
    // 加载状态
    func setLoading(_ loading: Bool) {
        isLoading = loading
    }
    
    // 更新用户信息
    func updateUser(_ user: User) {
        currentUser = user
    }
    
    // 完成引导
    func completeOnboarding() {
        showOnboarding = false
    }
}

// 应用错误类型
struct AppError: Identifiable, LocalizedError {
    let id = UUID()
    let error: Error
    
    var errorDescription: String? {
        error.localizedDescription
    }
    
    init(error: Error) {
        self.error = error
    }
}
