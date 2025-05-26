import SwiftUI

struct RechargeView: View {
    @StateObject private var viewModel = RechargeViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 余额显示
                HStack {
                    Text("当前余额:")
                    Text("\(viewModel.user.balance, specifier: "%.1f") 积分")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding()
                
                // 充值套餐
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.rechargePackages) { package in
                            RechargePackageView(
                                package: package,
                                isSelected: viewModel.selectedPackage == package,
                                onSelect: {
                                    viewModel.selectPackage(package)
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                // 支付按钮
                Button(action: viewModel.recharge) {
                    Text("立即充值")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedPackage == nil ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.selectedPackage == nil)
                .padding()
                
                // 充值记录
                if !viewModel.rechargeHistory.isEmpty {
                    Section(header: Text("充值记录")) {
                        List {
                            ForEach(viewModel.rechargeHistory) { record in
                                RechargeRecordRow(record: record)
                            }
                        }
                    }
                }
            }
            .navigationTitle("充值中心")
            .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
                Button("确定", role: .cancel) {}
            }
        }
    }
}

// 充值套餐视图
struct RechargePackageView: View {
    let package: RechargePackage
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 10) {
                Text("¥\(package.amount, specifier: "%.1f")")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(package.points, specifier: "%.1f") 积分")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text(package.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

// 充值记录行
struct RechargeRecordRow: View {
    let record: RechargeRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("¥\(record.amount, specifier: "%.1f")")
                    .font(.headline)
                Text("\(record.date.formatted(date: .numeric, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(record.points, specifier: "%.1f") 积分")
                .foregroundColor(record.status == .completed ? .green : .red)
        }
    }
}
