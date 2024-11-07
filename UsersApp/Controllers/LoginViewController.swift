import UIKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var emailErrorTF: UITextField!
    @IBOutlet weak var passwordErrorTF: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        setupNavBar()
        resetForm()
    }
    
    private func resetForm() {
        loginButton.isEnabled = false;
        
        emailErrorTF.isHidden = false;
        passwordErrorTF.isHidden = false;
        
        
    }
    
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTF.text {
            if let errorMessage = invalidEmail(email) {
                emailErrorTF.text = errorMessage
                emailErrorTF.isHidden = false
            } else {
                emailErrorTF.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let password = passwordTF.text {
            if let errorMessage = invalidPassword(password) {
                passwordErrorTF.text = errorMessage
                passwordErrorTF.isHidden = false
            } else {
                passwordErrorTF.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    @IBAction func login(_ sender: Any) {
        self.makeUsersViewController()
    }
    
    private func invalidEmail(_ value: String) -> String? {
        if value.count == 0 {return "Required"}
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: value) {
            return "Invalid Email Address"
        }
        return nil
    }
    
    private func invalidPassword(_ value: String) -> String? {
        if value.count == 0 {return "Required"}
        if value.count < 8 {
            return "Password must be at least 8 characters"
        }
        if containsDigits(value) {
            return "Password must contain at least 1 digit"
        }
        return nil
    }
    
    private func containsDigits(_ value: String) -> Bool {
        let passwordRegex = ".*[0-9]+.*"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return !passwordPredicate.evaluate(with: value)
    }
    
    private func checkForValidForm() {
        if emailErrorTF.isHidden && passwordErrorTF.isHidden {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    
    // MARK: - Google Sign In
    @IBAction func signIn(sender: Any) {
      GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
        guard error == nil else { return }

          self.makeUsersViewController()
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
    
    
    //TODO: start fetching already, optional: another animation, make all funcs private
    private func makeUsersViewController() {
        let usersViewController = UsersViewController()
        
        let navController = UINavigationController(rootViewController: usersViewController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: true, completion: nil)
    }
}

