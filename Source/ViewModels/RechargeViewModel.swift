import Foundation

class RechargeViewModel: ObservableObject {
    @Published var user: User
    @Published var selectedPackage: RechargePackage?
    @Published var rechargeHistory: [RechargeRecord] = []
    @Published var errorMessage: String = ""
    @Published var showError = false
    
    private let paymentService: PaymentService
    private let dataStore: DataStore
    
    init(user: User, paymentService: PaymentService = .shared, dataStore: DataStore = .shared) {
        self.user = user
        self.paymentService = paymentService
        self.dataStore = dataStore
        loadRechargeHistory()
    }
    
    // 充值套餐
    var rechargePackages: [RechargePackage] {
        [
            RechargePackage(amount: 9.9, points: 9.9, description: "新手体验包"),
            RechargePackage(amount: 49.9, points: 49.9, description: "基础套餐"),
            RechargePackage(amount: 99.9, points: 99.9, description: "尊享套餐"),
            RechargePackage(amount: 199.9, points: 199.9, description: "豪华套餐")
        ]
    }
    
    // 选择套餐
    func selectPackage(_ package: RechargePackage) {
        selectedPackage = package
    }
    
    // 充值
    func recharge() {
        guard let package = selectedPackage else { return }
        
        Task {
            do {
                try await paymentService.recharge(amount: package.amount) { result in
                    switch result {
                    case .success(let updatedUser):
                        // 更新用户信息
                        user = updatedUser
                        // 保存到数据存储
                        dataStore.updateUser(updatedUser)
                        // 刷新充值历史
                        loadRechargeHistory()
                    case .failure(let error):
                        errorMessage = "充值失败: \(error.localizedDescription)"
                        showError = true
                    }
                }
            } catch {
                errorMessage = "充值失败: \(error.localizedDescription)"
                showError = true
            }
        }
    }
    
    // 加载充值历史
    func loadRechargeHistory() {
        Task {
            do {
                rechargeHistory = try await paymentService.getRechargeHistory()
            } catch {
                errorMessage = "加载充值历史失败: \(error.localizedDescription)"
                showError = true
            }
        }
    }
}

// 充值套餐
struct RechargePackage {
    let amount: Double
    let points: Double
    let description: String
}
