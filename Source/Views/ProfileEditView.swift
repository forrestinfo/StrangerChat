import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProfileEditViewModel
    
    init(currentUser: User) {
        _viewModel = StateObject(wrappedValue: ProfileEditViewModel(user: currentUser))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("用户名", text: $viewModel.user.username)
                    Picker("性别", selection: $viewModel.user.gender) {
                        ForEach(User.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    TextField("年龄", value: $viewModel.user.age, formatter: NumberFormatter())
                }
                
                Section(header: Text("个人信息")) {
                    Picker("星座", selection: $viewModel.user.zodiacSign) {
                        ForEach(User.ZodiacSign.allCases, id: \.self) { sign in
                            Text(sign.rawValue).tag(sign)
                        }
                    }
                    Picker("血型", selection: $viewModel.user.bloodType) {
                        ForEach(User.BloodType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    // 头像上传
                    if let imageUrl = viewModel.user.profileImageURL {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Button(action: viewModel.uploadImage) {
                        Label("上传头像", systemImage: "photo")
                    }
                    .padding()
                    
                    TextField("个人简介", text: $viewModel.user.bio)
                    TextField("兴趣爱好", text: $viewModel.interests)
                        .keyboardType(.default)
                        .autocapitalization(.words)
                }
                
                Section {
                    Button(action: viewModel.save) {
                        Text("保存")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .disabled(!viewModel.isValid)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("编辑资料")
            .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
                Button("确定", role: .cancel) {}
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
}
