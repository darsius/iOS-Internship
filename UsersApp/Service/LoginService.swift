import Foundation
import GoogleSignIn

class LoginService {
    static let shared = LoginService()
    
    private init() {}
    
    func restorePreviousSignIn(completion: @escaping (Bool, GIDGoogleUser?) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                print("Successfully restored previous sign-in for user: \(user.profile?.email ?? "")")
                completion(true, user)
            } else if let error = error {
                print("Error restoring previous sign-in: \(error.localizedDescription)")
                completion(false, nil)
            } else {
                print("No previous user found")
                completion(false, nil)
            }
        }
    }
    
    func handleSignInURL(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
}
