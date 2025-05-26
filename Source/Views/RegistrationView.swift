import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("用户名", text: $viewModel.username)
                    Picker("性别", selection: $viewModel.gender) {
                        ForEach(User.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    TextField("年龄", value: $viewModel.age, formatter: NumberFormatter())
                }
                
                Section(header: Text("个人信息")) {
                    Picker("星座", selection: $viewModel.zodiacSign) {
                        ForEach(User.ZodiacSign.allCases, id: \.self) { sign in
                            Text(sign.rawValue).tag(sign)
                        }
                    }
                    Picker("血型", selection: $viewModel.bloodType) {
                        ForEach(User.BloodType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    TextField("个人简介", text: $viewModel.bio)
                    TextField("兴趣爱好", text: $viewModel.interests)
                        .keyboardType(.default)
                        .autocapitalization(.words)
                }
                
                Section {
                    Button(action: viewModel.register) {
                        Text("注册")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .disabled(!viewModel.isValid)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("注册")
            .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
                Button("确定", role: .cancel) {}
            }
        }
    }
}
