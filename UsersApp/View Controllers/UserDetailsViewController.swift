import UIKit

class UserDetailsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userFirstNameView: UserDetailView!
    @IBOutlet weak var userLastNameView: UserDetailView!
    
    var firstNameTitle = "First Name"
    var firstName : String?
    
    var lastNameTitle = "Last Name"
    var lastName : String?
    
    var userImageUrl: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageUrl = userImageUrl {
            setUpImageView(with: imageUrl)
        }
        setUpFirstNameView()
        setUpLastNameView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        self.textView.delegate = self
        
        if let previousText = userDefaults.value(forKey: userDefaultsKey) as? String {
            textView.text = previousText
        }
        
//        setupKeyboardHiding()
    }
    
    private func setUpImageView(with urlString: String) {
        userImageView.downloaded(from: urlString, contentMode: .scaleToFill)
        userImageView.layer.cornerRadius = userImageView.frame.size.height / 2
        userImageView.layer.masksToBounds = true
    }
    
    private func setUpFirstNameView() {
        userFirstNameView.contentViewTitle.text = firstNameTitle
        userFirstNameView.contentViewSubtitle.text = firstName
    }
    
    private func setUpLastNameView() {
        userLastNameView.contentViewTitle.text = lastNameTitle
        userLastNameView.contentViewSubtitle.text = lastName
    }
    
    //textView
    
    let userDefaults = UserDefaults()
    
    func textViewDidChange(_ textView: UITextView) {
        userDefaults.setValue(textView.text, forKey: userDefaultsKey)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    var userDefaultsKey: String {
        guard let userId = firstName else {
            fatalError("User ID is nil")
        }
        return "text_\(userId)"
    }
    
//    private func setupKeyboardHiding() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(sender: Notification) {
//        view.frame.origin.y -= 200
//    }
//
//    @objc func keyboardWillHide(sender: Notification) {
//        view.frame.origin.y = 0
//    }
}
