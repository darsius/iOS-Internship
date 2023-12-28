import UIKit

class UserDetailsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var outerDetailsStack: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var userFirstNameView: UserDetailView!
    @IBOutlet weak var userLastNameView: UserDetailView!
    
    var outerStackViewTopConstraintConstant: CGFloat = 25.0
    
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
        
        self.noteTextView.delegate = self
        
        if let previousText = userDefaults.value(forKey: userDefaultsKey) as? String {
            noteTextView.text = previousText
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillChangeFrameNotification, object: self)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
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
    
    var userDefaultsKey: String {
        guard let userId = firstName else {
            fatalError("User ID is nil")
        }
        return "text_\(userId)"
    }
    
    let userDefaults = UserDefaults()
    
    func textViewDidChange(_ textView: UITextView) {
        userDefaults.setValue(textView.text, forKey: userDefaultsKey)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        noteTextView.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardRectangle = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
        notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            view.frame.origin.y = -keyboardRectangle.height
        } else {
            view.frame.origin.y = 0
        }
    }
}
