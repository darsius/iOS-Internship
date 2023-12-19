import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restricRotation = .portrait
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
}
