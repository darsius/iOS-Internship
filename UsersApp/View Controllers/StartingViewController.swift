import UIKit
import Network

class StartingViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    //    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
//        startMonitoringInternetConnectivity()

//        activityIndicator.startAnimating()
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
            if NetworkMonitor.shared.isConnected {
                self.navigateToUsersViewController()
            } else {
                // TODO: alerta
                networkLabel.text = "neconectat \(NetworkMonitor.shared.isConnected)"
                print("Not connected")
            }
        }
    
//    func startMonitoringInternetConnectivity() {
//        DispatchQueue.main.async {
//            if NetworkMonitor.shared.isConnected {
//                print("navigating..")
//                self.navigateToUsersViewController()
//            }
//            else {
//                print("no")
//            }
//        }
//    }

    
//    func navigateToUsersViewController() {
//        networkLabel.text = "navigating.."
//        let usersViewController = UsersViewController()
//        
//        usersViewController.modalPresentationStyle = .fullScreen
//        
//        let navController = UINavigationController(rootViewController: usersViewController)
//
//        present(navController, animated: false, completion: nil)
//        
//    }
    
    func navigateToUsersViewController() {
        networkLabel.text = "navigating.."
        let usersViewController = UsersViewController()
        
        
        let navController = UINavigationController(rootViewController: usersViewController)
        
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: false, completion: nil)
        
    }
}
