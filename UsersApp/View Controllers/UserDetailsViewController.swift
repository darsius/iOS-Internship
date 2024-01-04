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
    
    private func setUpDobView() {
        let dobSubtitle = "Date: " + dobDate! + ", age: " + String(dobAge!)
        setUpDetailView(dateOfBirth, "Birth Date ", dobSubtitle)
    }
    private func setUpRegisteredView() {
        let registeredSubtitle = "Date: " + registeredDate! + ", age: " + String(registeredAge!)
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
    
    private func displayTextViewOutline() {
        noteTextView.layer.borderWidth = 0.7
        noteTextView.layer.borderColor = UIColor.black.cgColor
    }
}
