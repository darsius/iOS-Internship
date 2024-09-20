import UIKit
import Network

class LoadingViewController: UIViewController {

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        observeNetworkChanges()
    }
    
    private func observeNetworkChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToTabBarController(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func navigateToTabBarController(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            self.makeTabBarController()
        }
    }
    
    private func makeTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: false, completion: nil)
    }
}
