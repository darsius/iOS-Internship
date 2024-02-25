import UIKit
import Network

class LoadingViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToUsersViewController(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func navigateToUsersViewController(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            self.makeUsersViewController()
        }
    }
    
    private func makeUsersViewController() {
        let usersViewController = UsersViewController()
        
        let navController = UINavigationController(rootViewController: usersViewController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: false, completion: nil)
    }
}
