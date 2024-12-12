import Foundation
import UIKit

class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var onLoginSuccess: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
            let loginViewController = LoginViewController()
            loginViewController.onLoginComplete = { [weak self] in
                self?.onLoginSuccess?()
            }
            
            navigationController.setViewControllers([loginViewController], animated: false)
        }
}
