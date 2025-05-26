import Foundation
import SwiftUI
import PhotosUI

class ImageService {
    static let shared = ImageService()
    
    private init() {}
    
    // 选择图片
    func selectImage() async throws -> UIImage? {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        // 这里需要在主线程上显示选择器
        await MainActor.run {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let viewController = window.rootViewController {
                picker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                viewController.present(picker, animated: true)
            }
        }
        
        return nil // 实际使用时需要处理选择结果
    }
    
    // 压缩图片
    func compressImage(_ image: UIImage, maxSize: CGFloat = 1024) -> UIImage {
        let size = image.size
        let maxDimension = max(size.width, size.height)
        
        if maxDimension <= maxSize {
            return image
        }
        
        let scale = maxSize / maxDimension
        let newSize = CGSize(
            width: size.width * scale,
            height: size.height * scale
        )
        
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    // 上传图片到服务器
    func uploadImage(_ image: UIImage) async throws -> String {
        // 1. 压缩图片
        let compressedImage = compressImage(image)
        
        // 2. 转换为Data
        guard let imageData = compressedImage.jpegData(compressionQuality: 0.8) else {
            throw ImageError.encodingFailed
        }
        
        // 3. 生成唯一文件名
        let fileName = "profile_\(UUID().uuidString).jpg"
        
        // 4. 上传到服务器
        // 这里需要实现具体的上传逻辑
        // 可以使用URLSession或第三方库（如Alamofire）
        
        return "https://your-server.com/images/\(fileName)"
    }
    
    // 下载图片
    func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageError.decodingFailed
        }
        return image
    }
}

enum ImageError: Error {
    case encodingFailed
    case decodingFailed
    case uploadFailed
    case downloadFailed
}
