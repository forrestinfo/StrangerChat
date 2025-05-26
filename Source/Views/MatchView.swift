import SwiftUI

struct MatchView: View {
    @StateObject private var viewModel = MatchViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 匹配度筛选器
                    HStack {
                        Text("最小匹配度")
                        Slider(value: $viewModel.minimumCompatibility, in: 0...100, step: 1)
                        Text("\(Int(viewModel.minimumCompatibility))%")
                    }
                    .padding()
                    
                    // 匹配结果列表
                    ForEach(viewModel.matches, id: \.user.id) { match in
                        MatchCard(
                            user: match.user,
                            compatibility: match.compatibility,
                            isFavorite: viewModel.isFavorite(match.user.id)
                        )
                        .onTapGesture {
                            viewModel.selectMatch(match.user)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("匹配结果")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.refreshMatches) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

struct MatchCard: View {
    let user: User
    let compatibility: Double
    let isFavorite: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 用户头像
            AsyncImage(url: URL(string: user.profileImageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
            }
            
            // 用户信息
            VStack(alignment: .leading, spacing: 8) {
                Text(user.username)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "star.fill")
                    Text(user.zodiacSign.rawValue)
                }
                
                HStack {
                    Image(systemName: "drop.fill")
                    Text(user.bloodType.rawValue)
                }
                
                // 匹配度显示
                HStack {
                    Text("匹配度:")
                    Text("\(Int(compatibility))%")
                        .foregroundColor(compatibility > 80 ? .green : 
                                      compatibility > 60 ? .yellow : .red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
