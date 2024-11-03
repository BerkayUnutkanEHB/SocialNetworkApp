import SwiftUI
import FirebaseCore
import UserNotifications

// SocialNetworkApp
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Vraag toestemming voor notificaties
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Toestemming verleend voor notificaties.")
            } else {
                print("Toestemming geweigerd.")
            }
        }
        center.delegate = self
        
        return true
    }
}

@main
struct SocialNetworkAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
