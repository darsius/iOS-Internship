import Foundation
import GoogleSignIn

class LoginService {
    static let shared = LoginService()
    
    private init() {}
    
    func checkLoginState(completion: @escaping (Bool) -> Void) {
        if LoginManager.isLoggedIn() {
            print("User is logged in via credentials")
            completion(true)
            return
        }
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let _ = user {
                print("User is logged in via Google")
                completion(true)
            } else {
                print("No valid login session found")
                completion(false)
            }
        }
    }
    
    func handleSignInURL(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func logout() {
        LoginManager.setLoggedIn(false)
        GIDSignIn.sharedInstance.signOut()
        print("Logged out")
    }
    
}
