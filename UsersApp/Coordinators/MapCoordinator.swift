import Foundation
import UIKit

class MapCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapViewController = MapViewController()
        mapViewController.onUserAnnotationSelected = { [weak self] user in
            self?.showUserDetails(for: user)
        }
        navigationController.setViewControllers([mapViewController], animated: false)
    }
    
    func showUserDetails(for user: User) {
        let userDetailsViewController = UserDetailsViewController()
        userDetailsViewController.user = user
        navigationController.pushViewController(userDetailsViewController, animated: true)
    }
    
    
    
}
