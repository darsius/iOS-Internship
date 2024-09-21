import Foundation
import UIKit

class UsersManager {
    private var numberOfUsersDisplayed: Int = 100;
    private var orderOfUsersDisplayed: String = "abc"
    private var users: [User] = []
    
    static let shared = UsersManager()
    
    private init() {}
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        if users.isEmpty {
            fetchUsers { fetchedUsers in
                self.users = fetchedUsers
                completion(fetchedUsers)
            }
        } else {
            completion(users)
        }
    }
    
    private func fetchUsers(completion: @escaping ([User]) -> Void) {
        let networkManager = NetworkManager()
        Task {
            do {
                let fetchedUsers = try await networkManager.getUser(endpointResult: numberOfUsersDisplayed, endpointSeed: orderOfUsersDisplayed)
                DispatchQueue.main.async {
                    completion(fetchedUsers)
                }
            } catch let error as NetworkError {
                print("Network error: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
