import Foundation
import UIKit

class UsersManager {
    private var numberOfUsersDisplayed: Int = 100;
    private var orderOfUsersDisplayed: String = "abc"
    private var users: [User] = []
    
    static let shared = UsersManager()
    
    private init() {}
    
    func getUsers(on viewController: UIViewController, completion: @escaping ([User]) -> Void) {
        if users.isEmpty {
            fetchUsers(on: viewController) { fetchedUsers in
                self.users = fetchedUsers
                completion(fetchedUsers)
            }
        } else {
            completion(users)
        }
    }
    
    private func fetchUsers(on viewController: UIViewController, completion: @escaping ([User]) -> Void) {
        let networkManager = NetworkManager()
        Task {
            do {
                let fetchedUsers = try await networkManager.getUser(endpointResult: numberOfUsersDisplayed, endpointSeed: orderOfUsersDisplayed)
                DispatchQueue.main.async {
                    completion(fetchedUsers)
                }
            } catch let error as NetworkError {
                DispatchQueue.main.async {
                    CustomAlertManager.shared.showAlert(on: viewController, title: "Network Error", message: "Could not fetch the users: \(error.localizedDescription)")
                }
                print("Network error: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
