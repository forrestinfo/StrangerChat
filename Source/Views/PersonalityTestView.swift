import SwiftUI

struct PersonalityTestView: View {
    @StateObject private var viewModel = PersonalityTestViewModel()
    
    var body: some View {
        NavigationView {
            TabView(selection: $viewModel.currentTest) {
                // DISC性格测试
                DISCTestView(
                    questions: viewModel.discQuestions,
                    answers: $viewModel.discAnswers
                )
                .tabItem {
                    Label("DISC", systemImage: "person.fill")
                }
                .tag(PersonalityTestType.disc)
                
                // 九型人格测试
                EnneagramTestView(
                    questions: viewModel.enneagramQuestions,
                    answers: $viewModel.enneagramAnswers
                )
                .tabItem {
                    Label("九型人格", systemImage: "person.3.fill")
                }
                .tag(PersonalityTestType.enneagram)
                
                // 十六型人格测试
                MBTITestView(
                    questions: viewModel.mbtiQuestions,
                    answers: $viewModel.mbtiAnswers
                )
                .tabItem {
                    Label("十六型人格", systemImage: "person.2.fill")
                }
                .tag(PersonalityTestType.mbti)
                
                // 盖洛普优势测试
                StrengthsFinderTestView(
                    questions: viewModel.strengthsFinderQuestions,
                    answers: $viewModel.strengthsFinderAnswers
                )
                .tabItem {
                    Label("优势", systemImage: "star.fill")
                }
                .tag(PersonalityTestType.strengthsFinder)
            }
            .navigationTitle("性格测试")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.submitTest) {
                        Text("提交")
                    }
                    .disabled(!viewModel.canSubmit)
                }
            }
        }
    }
}

// 测试类型
enum PersonalityTestType: String, CaseIterable {
    case disc = "DISC"
    case enneagram = "九型人格"
    case mbti = "十六型人格"
    case strengthsFinder = "优势"
}

// 测试问题
struct TestQuestion: Identifiable {
    let id: Int
    let text: String
    let options: [String]
}

// 测试视图
struct TestQuestionView: View {
    let question: TestQuestion
    @Binding var answer: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question.text)
                .font(.headline)
            
            ForEach(0..<question.options.count, id: \.self) { index in
                Button(action: { answer = index }) {
                    HStack {
                        if answer == index {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "circle")
                        }
                        Text(question.options[index])
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}
