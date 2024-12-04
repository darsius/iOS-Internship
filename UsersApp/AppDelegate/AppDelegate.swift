import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NetworkMonitor.shared.initiateConnectivityTracking()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                print("Successfully restored previous sign-in for user: \(user.profile?.email ?? "")")
                self.showSignedInState(for: user)
            } else if let error = error {
                print("Error restoring previous sign-in: \(error.localizedDescription)")
                self.showSignedOutState()
            } else {
                print("No previous user found")
                self.showSignedOutState()
            }
        }
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        return false
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func showSignedOutState() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    private func showSignedInState(for user: GIDGoogleUser) {
        let usersViewController = UsersViewController()
        let navigationController = UINavigationController(rootViewController: usersViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
