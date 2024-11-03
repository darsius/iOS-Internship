import UIKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInAppleStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        setupNavBar()
    }
    
    @IBAction func signIn(sender: Any) {
      GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
        guard error == nil else { return }

        // If sign in succeeded, display the app's main content View.
      }
    }
    
    private func setupNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22)
        ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.title = "Sign In"
        
    }
    
    @IBAction func login(_ sender: Any) {
        self.makeUsersViewController()
    }
    
    
    //TODO: start fetching already, optional: another animation
    private func makeUsersViewController() {
        let usersViewController = UsersViewController()
        
        let navController = UINavigationController(rootViewController: usersViewController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: true, completion: nil)
    }
}

