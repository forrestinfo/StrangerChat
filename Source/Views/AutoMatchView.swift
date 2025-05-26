import SwiftUI

struct AutoMatchView: View {
    @StateObject private var viewModel = AutoMatchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // 匹配设置
                VStack(alignment: .leading, spacing: 12) {
                    Text("匹配设置")
                        .font(.headline)
                    
                    Toggle("自动匹配", isOn: $viewModel.isAutoMatching)
                        .tint(.blue)
                    
                    if viewModel.isAutoMatching {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("匹配频率")
                            Picker("", selection: $viewModel.matchFrequency) {
                                Text("每小时").tag(60 * 60)
                                Text("每2小时").tag(60 * 60 * 2)
                                Text("每4小时").tag(60 * 60 * 4)
                                Text("每8小时").tag(60 * 60 * 8)
                            }
                            .pickerStyle(.segmented)
                            
                            Text("匹配数量")
                            Picker("", selection: $viewModel.matchCount) {
                                Text("5个").tag(5)
                                Text("10个").tag(10)
                                Text("15个").tag(15)
                                Text("20个").tag(20)
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
                .padding()
                
                // 匹配建议
                if !viewModel.matchSuggestions.isEmpty {
                    List {
                        ForEach(viewModel.matchSuggestions) { suggestion in
                            NavigationLink {
                                MatchDetailView(
                                    user: suggestion.user,
                                    compatibility: suggestion.compatibility
                                )
                            } label: {
                                MatchSuggestionRow(
                                    user: suggestion.user,
                                    compatibility: suggestion.compatibility,
                                    analysis: suggestion.analysis
                                )
                            }
                        }
                    }
                } else {
                    EmptyState(
                        message: "暂时没有匹配建议",
                        image: "person.2.fill",
                        action: {
                            viewModel.refreshSuggestions()
                        }
                    )
                }
            }
            .navigationTitle("自动匹配")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.refreshSuggestions) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
            Button("确定", role: .cancel) {}
        }
    }
}

// 匹配建议行
struct MatchSuggestionRow: View {
    let user: User
    let compatibility: Double
    let analysis: MatchAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 用户信息
            HStack {
                AsyncImage(url: URL(string: user.profileImageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.username)
                        .font(.headline)
                    Text("\(user.age)岁, \(user.gender.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            // 匹配度分析
            HStack {
                Text("\(Int(compatibility))% 匹配")
                    .font(.headline)
                    .foregroundColor(analysis.compatibilityColor)
                
                Spacer()
                
                Text(analysis.compatibilityLevel)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
