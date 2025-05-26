import SwiftUI

struct MatchDetailView: View {
    let user: User
    let compatibility: Double
    @State private var isLiked = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 用户头像
                AsyncImage(url: URL(string: user.profileImageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 200, height: 200)
                }
                
                // 用户信息
                VStack(alignment: .leading, spacing: 12) {
                    Text(user.username)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "person.fill")
                        Text("\(user.age)")
                    }
                    
                    HStack {
                        Image(systemName: "star.fill")
                        Text(user.zodiacSign.rawValue)
                    }
                    
                    HStack {
                        Image(systemName: "hare.fill")
                        Text(user.chineseZodiac.rawValue)
                    }
                    
                    HStack {
                        Image(systemName: "drop.fill")
                        Text(user.bloodType.rawValue)
                    }
                    
                    // 匹配度分析
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "heart.fill")
                            Text("\(Int(compatibility))% 总体匹配")
                                .foregroundColor(compatibility > 80 ? .green : 
                                              compatibility > 60 ? .yellow : .red)
                        }
                        
                        // 匹配度细分
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "star.fill")
                                Text("\(Int(zodiacScore * 100))% 星座匹配")
                            }
                            HStack {
                                Image(systemName: "hare.fill")
                                Text("\(Int(chineseZodiacScore * 100))% 生肖匹配")
                            }
                            HStack {
                                Image(systemName: "drop.fill")
                                Text("\(Int(bloodScore * 100))% 血型匹配")
                            }
                            HStack {
                                Image(systemName: "person.3.fill")
                                Text("\(Int(personalityScore * 100))% 性格匹配")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
                
                // 兴趣爱好
                VStack(alignment: .leading, spacing: 8) {
                    Text("兴趣爱好").font(.headline)
                    ForEach(user.interests, id: \.self) { interest in
                        Text("• \(interest)")
                            .font(.subheadline)
                    }
                }
                .padding()
                
                // 个人简介
                VStack(alignment: .leading, spacing: 8) {
                    Text("个人简介").font(.headline)
                    Text(user.bio)
                        .font(.subheadline)
                }
                .padding()
                
                // 操作按钮
                HStack(spacing: 20) {
                    Button(action: {
                        // TODO: 实现消息功能
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("发送消息")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        isLiked.toggle()
                        // TODO: 实现喜欢功能
                    }) {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                            Text(isLiked ? "已喜欢" : "喜欢")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationTitle("匹配详情")
    }
}
