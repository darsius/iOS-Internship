import UIKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    
    @IBOutlet private weak var emailErrorTF: UITextField!
    @IBOutlet private weak var passwordErrorTF: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    
    private let refreshToken: TimeInterval = 3600
    
    private struct PasswordRules {
        static let minLength = 8
        static let maxLength = 64
    }
    
    private struct EmailRules {
        static let minLength = 6
        static let maxLength = 256
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setUpPlaceholders()
        resetForm()
        handleKeyboardBehaviour()
    }
    
    private func setupNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22)
        ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.title = "Welcome to Users App"
    }
    
    private func setUpPlaceholders() {
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
    }
    
    private func resetForm() {
        loginButton.isEnabled = false;
        emailErrorTF.isHidden = false;
        passwordErrorTF.isHidden = false;
    }
    
    @IBAction private func emailChanged(_ sender: Any) {
        if let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if let errorMessage = invalidEmailFormat(email) {
                emailErrorTF.text = errorMessage
                emailErrorTF.isHidden = false
            } else {
                emailErrorTF.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    @IBAction private func passwordChanged(_ sender: Any) {
        if let password = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if let errorMessage = invalidPasswordFormat(password) {
                passwordErrorTF.text = errorMessage
                passwordErrorTF.isHidden = false
            } else {
                passwordErrorTF.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    // MARK: - Login Logic
    @IBAction private func login(_ sender: Any) {
        guard let email = self.emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = self.passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let currentTime = Date()
        if email == LoginConstants.hardcodedEmail && password == LoginConstants.hardcodedPassword {
            let expiration = currentTime.addingTimeInterval(refreshToken)
            LoginManager.setLoggedIn(true, expiration: expiration)
            self.makeUsersViewController()
        } else {
            let alert = UIAlertController(
                title: "Wrong email or password.",
                message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction private func signInWithGoogle(sender: Any) {
      GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
        guard let self = self, error == nil else { return }
          
          self.makeUsersViewController()
      }
    }
    
    // MARK: - Validation
    private func invalidEmailFormat(_ value: String) -> String? {
        if value.count == 0 {return "Required"}
        if value.count < EmailRules.minLength {return "Email must be at least \(EmailRules.minLength) characters"}
        if value.count > EmailRules.maxLength {return "Email must be at most \(EmailRules.maxLength) characters"}
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: value) {
            return "Invalid Email Address format"
        }
        
        return nil
    }
    
    private func invalidPasswordFormat(_ value: String) -> String? {
        if value.count == 0 {return "Required"}
        if value.count < PasswordRules.minLength {return "Password must be at least \(PasswordRules.minLength) characters"}
        if value.count > PasswordRules.maxLength {return "Password must be at most  \(PasswordRules.maxLength) characters"}
        if value.contains(" ") {return "Password cannot contain spaces"}
        if !containsDigits(value) {
            return "Password must contain at least 1 digit"
        }
        
        return nil
    }
    
    private func containsDigits(_ value: String) -> Bool {
        let passwordRegex = ".*[0-9]+.*"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: value)
    }
    
    private func checkForValidForm() {
        if emailErrorTF.isHidden && passwordErrorTF.isHidden {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    private func makeUsersViewController() {
        let usersViewController = UsersViewController()
        
        let navController = UINavigationController(rootViewController: usersViewController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: true, completion: nil)
    }
}

// MARK: - Keyboard Behaviour
extension LoginViewController {
    private func handleKeyboardBehaviour() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillChangeFrameNotification, object: self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification ||
        notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -40
        } else {
            view.frame.origin.y = 0
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
}
