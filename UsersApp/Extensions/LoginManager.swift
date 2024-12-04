import Foundation
struct LoginManager {
    static let isLoggedInKey = "isLoggedIn"
    static let loginExpirationKey = "loginExpiration"

    static func setLoggedIn(_ isLoggedIn: Bool, expiration: Date? = nil) {
        UserDefaults.standard.set(isLoggedIn, forKey: isLoggedInKey)
        if let expiration = expiration {
            UserDefaults.standard.set(expiration, forKey: loginExpirationKey)
        } else {
            UserDefaults.standard.removeObject(forKey: loginExpirationKey)
        }
        UserDefaults.standard.synchronize()
    }

    static func isLoggedIn() -> Bool {
        let isLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
        if isLoggedIn {
            if let expiration = UserDefaults.standard.object(forKey: loginExpirationKey) as? Date {
                if expiration > Date() {
                    return true
                } else {
                    print("Login expired")
                    setLoggedIn(false)
                }
            } else {
                print("No expiration date saved")
            }
        } else {
            print("User is not logged in")
        }
        return false
    }

    static func logOut() {
        print("Logging out")
        setLoggedIn(false)
    }
}
