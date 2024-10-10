import Foundation
import UIKit

class CustomAlertManager {
    static let shared = CustomAlertManager()
    
    private init() {}
    
    func showAlert(on viewController: UIViewController, title: String, message: String, actionTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
                    completion?()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
