import Foundation

public struct AppOrchestra {
    public static func home() {
        NotificationCenter.default.post(name: .lightLogIn, object: nil)
    }
    
    public static func onboarding() {
        NotificationCenter.default.post(name: .lightLogOut, object: nil)
    }
}
