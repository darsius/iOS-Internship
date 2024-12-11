import Foundation
import UIKit

class UsersCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let usersViewController = UsersViewController()
        usersViewController.onUserSelected = { [weak self] user in
            self?.showUserDetails(for: user)
        }
        
        navigationController.setViewControllers([usersViewController], animated: false)
    }
    
    func showUserDetails(for user: User) {
        let userDetailsViewController = UserDetailsViewController()
        userDetailsViewController.user = user
        navigationController.pushViewController(userDetailsViewController, animated: true)
    }
}
