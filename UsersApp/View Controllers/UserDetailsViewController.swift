import UIKit


class UserDetailsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var firstNameView: UserDetailView!
    @IBOutlet weak var lastNameView: UserDetailView!
    @IBOutlet weak var genderView: UserDetailView!
    @IBOutlet weak var streetAdressView: UserDetailView!
    @IBOutlet weak var cityView: UserDetailView!
    @IBOutlet weak var stateView: UserDetailView!
    @IBOutlet weak var countryView: UserDetailView!
    @IBOutlet weak var postalCodeView: UserDetailView!
    @IBOutlet weak var coordinatesView: UserDetailView!
    @IBOutlet weak var timezoneView: UserDetailView!
    @IBOutlet weak var emailView: UserDetailView!
    @IBOutlet weak var dateOfBirth: UserDetailView!
    @IBOutlet weak var registeredDateView: UserDetailView!
    @IBOutlet weak var phoneView: UserDetailView!
    @IBOutlet weak var cellphoneView: UserDetailView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var userImageUrl: String?
    
    var firstName : String?
    var lastName : String?
    var gender: String?
    
    var streetAdress: String?
    var city: String?
    var state: String?
    var country: String?
    var postalCode: PostalCode?
    var coordinatesLatitude: String?
    var coordinatesLongitude: String?
    var timezoneOffset: String?
    var timezoneDescription: String?
    
    var email: String?
    var dobDate: String?
    var dobAge: Int?
    var registeredDate: String?
    var registeredAge: Int?
    var phone: String?
    var cellphone: String?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        noteTextView.delegate = self
        
        saveNoteContent()
        
        if let imageUrl = userImageUrl {
            setUpImageView(with: imageUrl)
        }
        setUpFirstNameView()
        setUpLastNameView()
        setUpGenderView()
        setUpLocationView()
        setUpEmailView()
        setUpDobView()
        setUpRegisteredView()
        setUpPhoneView()
        setUpCellphoneView()
        
        displayTextViewOutline()
        disableEmptyNoteButtons()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillChangeFrameNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: noteTextView)
        
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
    }
    
    
    private func setUpImageView(with urlString: String) {
        userImageView.downloaded(from: urlString) { [weak self] _ in
            guard let self = self else { return }

            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
            self.userImageView.layer.masksToBounds = false
            self.userImageView.clipsToBounds = true
        }
    }
    
    private func setUpDetailView(_ view: UserDetailView ,_ title: String, _ subtitle: String!) {
        view.contentViewTitle.text = title
        view.contentViewSubtitle.text = subtitle
    }
    
    private func setUpFirstNameView() {
        setUpDetailView(firstNameView, "First Name", firstName)
    }
    
    private func setUpLastNameView() {
        setUpDetailView(lastNameView, "Last Name", lastName)
    }
    
    private func setUpGenderView() {
        setUpDetailView(genderView, "Gender", gender)
    }
    
    private func setUpLocationView() {
        setUpDetailView(cityView, "City", city)
        setUpDetailView(stateView, "State", state)
        setUpDetailView(streetAdressView, "Street Adress", streetAdress)
        setUpDetailView(countryView, "Country", country)
        setUpDetailView(postalCodeView, "Postal Code", postalCode?.description)
        
        let coordinatesSubtitle = "latitude: " + coordinatesLatitude! + "\nlongitude: " + coordinatesLongitude!
        setUpDetailView(coordinatesView, "Coordinates", coordinatesSubtitle)
        
        let timezoneSubtitle = "offset: " + timezoneOffset! + "\n" + timezoneDescription!
        setUpDetailView(timezoneView, "Timezone", timezoneSubtitle)
    }
    
    private func setUpEmailView() {
        setUpDetailView(emailView, "Email", email)
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
    
    private func setUpDobView() {
        let dobSubtitle = "Date: " + formateDateString(dobDate!) + ", age: " + String(dobAge!)
        setUpDetailView(dateOfBirth, "Birth Date ", dobSubtitle)
    }
    
    private func setUpRegisteredView() {
        let registeredSubtitle = "Date: " + formateDateString(registeredDate!) + ", age: " + String(registeredAge!)
        setUpDetailView(registeredDateView, "Registered ", registeredSubtitle)
    }
    
    private func setUpPhoneView() {
        setUpDetailView(phoneView, "Phone", phone)
    }
    
    private func setUpCellphoneView() {
        setUpDetailView(cellphoneView, "Cellphone", cellphone)
    }
    
    //textView
    
    var userDefaultsKey: String {
        guard let userId = dobDate else {
            print("User ID is nil")
            return "0"
        }
        return "text_\(userId)"
    }
    
    let userDefaults = UserDefaults()
    
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
    
    internal func saveNoteContent() {
        if let previousText = userDefaults.value(forKey: userDefaultsKey) as? String {
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
            saveButton.isHidden = true
        }
    }
    
    @IBAction func saveNote(_ sender: Any) {
        if !noteTextView.text.isEmpty {
            userDefaults.setValue(noteTextView.text, forKey: userDefaultsKey)
            handleTap(UITapGestureRecognizer())
        }
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        if !noteTextView.text.isEmpty {
            userDefaults.removeObject(forKey: userDefaultsKey)
            noteTextView.text = ""
        }
        else {
            deleteButton.isHidden = false
        }
    }
}
