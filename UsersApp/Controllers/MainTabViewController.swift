import UIKit

class MainTabViewController: UITabBarController {
    private var noConnectionBanner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        observeNetworkChanges()
    }
    
    private func setupTabBarAppearance() {
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.barTintColor = .systemYellow
        tabBar.backgroundColor = .systemYellow
    }
    
    // MARK: - network
    private func observeNetworkChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(manageNoInternetConnection(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func manageNoInternetConnection(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !NetworkMonitor.shared.isConnected {
                let alert = UIAlertController(
                    title: "No internet",
                    message: "You're offline. Check you connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                    title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
