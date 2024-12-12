import UIKit
import Network

class LoadingViewController: UIViewController {
    
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    var onLoadComplete: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        observeNetworkChanges()
    }
    
    private func observeNetworkChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectionEstablished(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func connectionEstablished(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            self.onLoadComplete?()
        }
    }
}
