import UIKit
import Network

class StartingViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
            if NetworkMonitor.shared.isConnected {
                self.navigateToUsersViewController()
            } else {
                // TODO: alert
                
                print("Not connected")
            }
        }
    
    func navigateToUsersViewController() {
        let usersViewController = UsersViewController()
        
        let navController = UINavigationController(rootViewController: usersViewController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: false, completion: nil)
        
    }
}
