import Foundation


class UserData {
    static let shared = UserData()
    var users: [User] = []
    private init() {}
}
