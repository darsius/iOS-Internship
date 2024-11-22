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

        setupNavBar()
        resetForm()
        handleKeyboardBehaviour()
        
    }
    
    private func handleKeyboardBehaviour() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillChangeFrameNotification, object: self)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
        notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            view.frame.origin.y = -20
        } else {
            view.frame.origin.y = 0
        }
    }
    
    private func resetForm() {
        loginButton.isEnabled = false;
        emailErrorTF.isHidden = false;
        passwordErrorTF.isHidden = false;
    }
    
    @IBAction func emailChanged(_ sender: Any) {
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
    
    @IBAction func passwordChanged(_ sender: Any) {
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
    
    @IBAction func login(_ sender: Any) {
        print(1)
        guard let email = self.emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = self.passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if email == LoginConstants.hardcodedEmail && password == LoginConstants.hardcodedPassword {
            self.makeUsersViewController()
        } else {
            let alert = UIAlertController(
                title: "Wrong email or password.",
                message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        print(2)
    }
    
    private func invalidEmailFormat(_ value: String) -> String? {
        if value.count == 0 {return "Required"}
        if value.count < 6 {return "Email must be at least 6 characters"}
        if value.count > 256 {return "Email must be at most 256 characters"}
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: value) {
            return "Invalid Email Address format"
        }
        
        return nil
    }
    
    private func invalidPasswordFormat(_ value: String) -> String? {
        if value.count == 0 {return "Required"}
        if value.count < 8 {return "Password must be at least 8 characters"}
        if value.count > 64 {return "Password must be at most 8 characters"}
        if value.contains(" ") {return "Password cannot contain spaces"}
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
    @IBAction func signInWithGoogle(sender: Any) {
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
        navigationItem.title = "Welcome to Users App"
        
    }
    
    
    //TODO: start fetching already, optional: another animation, make all funcs private
    private func makeUsersViewController() {
        let usersViewController = UsersViewController()
        
        let navController = UINavigationController(rootViewController: usersViewController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: true, completion: nil)
    }
}

