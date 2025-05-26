import SwiftUI

// 加载动画
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1.0)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .frame(width: 50, height: 50)
            
            Text("加载中...")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// 错误提示
struct ErrorAlert: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.system(size: 40))
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: onRetry) {
                Text("重试")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            
            Button(action: {
                // 关闭错误提示
            }) {
                Text("取消")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

// 空状态提示
struct EmptyState: View {
    let message: String
    let image: String
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
            
            if let action = action {
                Button(action: action) {
                    Text("开始")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
        }
        .padding()
    }
}

// 引导提示
struct OnboardingView: View {
    let steps: [OnboardingStep]
    
    var body: some View {
        TabView {
            ForEach(steps) { step in
                VStack(spacing: 20) {
                    Image(step.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    
                    Text(step.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(step.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle())
    }
}

// 引导提示步骤
struct OnboardingStep {
    let image: String
    let title: String
    let description: String
}
