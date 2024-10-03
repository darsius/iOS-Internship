import UIKit


class UserDetailsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak private var userImageView: UIImageView!
    
    @IBOutlet weak private var noteTextView: UITextView!
    
    @IBOutlet weak private var firstNameView: UserDetailView!
    @IBOutlet weak private var lastNameView: UserDetailView!
    @IBOutlet weak private var genderView: UserDetailView!
    
    @IBOutlet weak private var streetAddressLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var stateLabel: UILabel!
    @IBOutlet weak private var countryLabel: UILabel!
    @IBOutlet weak private var postalCodeLabel: UILabel!
    @IBOutlet weak private var coordinatesLabel: UILabel!
    @IBOutlet weak private var timezoneLabel: UILabel!
    
    @IBOutlet weak private var emailView: UserDetailView!
    @IBOutlet weak private var dateOfBirth: UserDetailView!
    @IBOutlet weak private var registeredDateView: UserDetailView!
    @IBOutlet weak private var phoneView: UserDetailView!
    @IBOutlet weak private var cellphoneView: UserDetailView!
    
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var saveButton: UIButton!
    
    
    private let userDefaults = UserDefaults()
    
    internal var user: User?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        noteTextView.delegate = self
                
        saveNoteContent()
        
        configureDetails()
        
        configureNoteTextView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: noteTextView)
        
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
    }
    
    private func setUpDetailView(view: UserDetailView, _ title: String, _ subtitle: String) {
        view.contentViewTitle.text = title
        view.contentViewSubtitle.text = subtitle
    }
    
    private func configureDetails() {
        guard let user = user else {
            return
        }
        
        setUpImageView(with: user.picture.large)
        
        setUpDetailView(view: firstNameView, "First Name", user.name.first)
        setUpDetailView(view: lastNameView, "Last Name", user.name.last)
        setUpDetailView(view: genderView, "Gender", user.gender)
        
        configureLocationView(user)
        
        configureDobView(user)
        
        configureRegisteredView(user)
        
        setUpDetailView(view: emailView, "Email", user.email)
        setUpDetailView(view: cellphoneView, "Cellphone", user.cell)
        setUpDetailView(view: phoneView, "Phone", user.phone)
    }
    
    private func setUpImageView(with urlString: String) {
//        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        self.userImageView.layer.masksToBounds = false
        self.userImageView.clipsToBounds = true
        userImageView.downloaded(from: urlString) { result in
            switch result {
            case .success(let image):
                self.userImageView.image = image
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
                let defaultImage = UIImage(systemName: "person.fill")
                DispatchQueue.main.async {
                    self.userImageView.image = defaultImage
                }
            }
        }
    }
    
    private func configureLocationView(_ user: User) {
        let location = user.location
        streetAddressLabel.text = location.street.name
        cityLabel.text = location.city
        stateLabel.text = location.state
        countryLabel.text = location.country
        postalCodeLabel.text = location.postcode.description
        coordinatesLabel.text = "latitude: " + location.coordinates.latitude + "\n longitude: " + location.coordinates.longitude
        timezoneLabel.text = "offset: " + location.timezone.offset + "\n" + location.timezone.description
    }
    
    private func configureDobView(_ user: User) {
        let dobSubtitle = "Date: " + formateDateString(user.dob.date) + ", age: " + String(user.dob.age)
        setUpDetailView(view: dateOfBirth, "Birth Date ", dobSubtitle)
    }
    
    private func configureRegisteredView(_ user: User) {
        let registeredSubtitle = "Date: " + formateDateString(user.registered.date) + ", age: " + String(user.registered.age)
        setUpDetailView(view: registeredDateView, "Registered ", registeredSubtitle)
    }
    
    private func formateDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM d yyyy, h:m a"
            return dateFormatter.string(from: date)
        } else {
            return "0--0 000"
        }
    }
}
    
// MARK: - noteTextViewMethods
extension UserDetailsViewController {
    
    private func configureNoteTextView() {
        displayTextViewOutline()
        disableEmptyNoteButtons()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillChangeFrameNotification, object: self)
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
    
    private func getUsersEmail() -> String {
        guard let user = user else {
            print("error at getting the user's email")
            return ""
        }
        return user.email
    }
    
    private func saveNoteContent() {
        let email = getUsersEmail()
        if let previousText = userDefaults.value(forKey: email) as? String {
            noteTextView.text = previousText
        }
    }
    
    private func displayTextViewOutline() {
        noteTextView.layer.borderWidth = 0.7
        noteTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    internal func textViewDidChange(_ textView: UITextView) {
        saveButton.isHidden = textView.text.isEmpty
    }
    
    private func disableEmptyNoteButtons() {
        if noteTextView.text.isEmpty {
            deleteButton.isHidden = true
        }
        else {
            swapButtons()
        }
        saveButton.isHidden = true
    }
    
    @IBAction private func saveNote(_ sender: Any) {
        if !noteTextView.text.isEmpty {
            let email = getUsersEmail()
            userDefaults.setValue(noteTextView.text, forKey: email)
            handleTap(UITapGestureRecognizer())
            saveButton.isHidden = true
            swapButtons()
            deleteButton.isHidden = false
        }
    }
    
    @IBAction private func deleteNote(_ sender: Any) {
        if !noteTextView.text.isEmpty {
            let email = getUsersEmail()
            userDefaults.removeObject(forKey: email)
            noteTextView.text = ""
            swapButtons()
            deleteButton.isHidden = true
            saveButton.isHidden = true
        }
    }
    
    private func swapButtons() {
        let tempButton = saveButton.center
        saveButton.center = deleteButton.center
        deleteButton.center = tempButton
    }
}
