import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    // 请求通知权限
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }
    
    // 发送匹配通知
    func sendMatchNotification(user: User, compatibility: Double) {
        let content = UNMutableNotificationContent()
        content.title = "新匹配！"
        content.body = "您与\(user.username)的匹配度为\(Int(compatibility))%"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }
    
    // 发送消息通知
    func sendNewMessageNotification(user: User, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "新消息！"
        content.body = "\(user.username): \(message)"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }
    
    // 发送测试完成通知
    func sendTestCompletionNotification(testType: PersonalityTestType) {
        let content = UNMutableNotificationContent()
        content.title = "测试完成！"
        content.body = "您已完成\(testType.rawValue)测试，查看结果吧！"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }
}
