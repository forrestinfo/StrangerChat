import SwiftUI

struct TestResultView: View {
    let result: PersonalityTestResult
    
    var body: some View {
        NavigationView {
            TabView {
                // DISC性格结果
                DISCResultView(result: result.disc)
                    .tabItem {
                        Label("DISC", systemImage: "person.fill")
                    }
                
                // 九型人格结果
                EnneagramResultView(result: result.enneagram)
                    .tabItem {
                        Label("九型人格", systemImage: "person.3.fill")
                    }
                
                // 十六型人格结果
                MBTIResultView(result: result.mbti)
                    .tabItem {
                        Label("十六型人格", systemImage: "person.2.fill")
                    }
                
                // 盖洛普优势结果
                StrengthsFinderResultView(result: result.strengthsFinder)
                    .tabItem {
                        Label("优势", systemImage: "star.fill")
                    }
            }
            .navigationTitle("测试结果")
        }
    }
}

// DISC性格结果视图
struct DISCResultView: View {
    let result: PersonalityTestResult.DISCResult
    
    var body: some View {
        VStack(spacing: 20) {
            Text("您的主要性格类型是：\(result.primaryStyle.rawValue)")
                .font(.title)
                .fontWeight(.bold)
            
            Text("次要性格类型：\(result.secondaryStyle.rawValue)")
                .font(.headline)
            
            // 性格特征分布图
            ChartView(
                data: [
                    ("支配性", result.dominance),
                    ("影响性", result.influence),
                    ("稳定性", result.steadiness),
                    ("遵从性", result.compliance)
                ]
            )
            
            // 性格特征描述
            Text("性格特征描述")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("优点：")
                        .font(.subheadline)
                    Text("缺点：")
                        .font(.subheadline)
                    Text("建议：")
                        .font(.subheadline)
                }
                .padding()
            }
        }
        .padding()
    }
}

// 九型人格结果视图
struct EnneagramResultView: View {
    let result: PersonalityTestResult.EnneagramResult
    
    var body: some View {
        VStack(spacing: 20) {
            Text("您的九型人格类型是：\(result.type)型")
                .font(.title)
                .fontWeight(.bold)
            
            if let wing = result.wing {
                Text("翼型：\(wing)")
                    .font(.headline)
            }
            
            Text("发展水平：\(result.level)")
                .font(.headline)
            
            // 类型特征描述
            Text("类型特征描述")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("优点：")
                        .font(.subheadline)
                    Text("缺点：")
                        .font(.subheadline)
                    Text("发展建议：")
                        .font(.subheadline)
                }
                .padding()
            }
        }
        .padding()
    }
}

// 十六型人格结果视图
struct MBTIResultView: View {
    let result: PersonalityTestResult.MBTIResult
    
    var body: some View {
        VStack(spacing: 20) {
            Text("您的性格类型是：\(result.type)")
                .font(.title)
                .fontWeight(.bold)
            
            // 性格特征分布图
            ChartView(
                data: result.scores.map { ("\($0.trait.rawValue)", $0.score) }
            )
            
            // 类型特征描述
            Text("类型特征描述")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("优点：")
                        .font(.subheadline)
                    Text("挑战：")
                        .font(.subheadline)
                    Text("职业建议：")
                        .font(.subheadline)
                }
                .padding()
            }
        }
        .padding()
    }
}

// 盖洛普优势结果视图
struct StrengthsFinderResultView: View {
    let result: PersonalityTestResult.StrengthsFinderResult
    
    var body: some View {
        VStack(spacing: 20) {
            Text("您的优势主题")
                .font(.title)
                .fontWeight(.bold)
            
            // 优势主题列表
            VStack(spacing: 12) {
                ForEach(result.topFive, id: \.self) { strength in
                    HStack {
                        Image(systemName: "star.fill")
                        Text(strength.rawValue)
                    }
                }
            }
            
            // 完整优势列表
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(result.fullResults, id: \.self) { strength in
                        Text(strength.rawValue)
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

// 图表视图
struct ChartView: View {
    let data: [(String, Double)]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(data.indices, id: \.self) { index in
                        let (label, value) = data[index]
                        let height = geometry.size.height * value
                        
                        Rectangle()
                            .fill(Color.blue.opacity(0.5))
                            .frame(height: height)
                            .offset(y: -height/2)
                            .overlay(
                                Text("\(Int(value * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .background(Color.blue)
                                    .cornerRadius(4)
                                    .offset(y: -height/2 - 20)
                            )
                    }
                }
                .frame(height: 200)
                
                HStack {
                    ForEach(data.indices, id: \.self) { index in
                        Text(data[index].0)
                            .font(.caption)
                            .rotationEffect(.degrees(-45))
                    }
                }
            }
        }
    }
}
