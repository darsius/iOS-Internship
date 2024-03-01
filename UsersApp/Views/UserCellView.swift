import UIKit


class UserCellView: UITableViewCell {

    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var userImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupImageView(with urlString: String) {
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
        userImageView.layer.cornerRadius = userImageView.frame.size.height / 2
        userImageView.layer.masksToBounds = true
    }
    
    func setupTimeLabel(with userTime: String) {
        let components = userTime.split(separator: ":")

        guard components.count == 2,
              let hours = Double(components[0]),
              let minutes = Double(components[1])
        else {
            print("invalid time as string")
            return
        }
        
        let userTimeHours = hours + (minutes / 60)
        let currentTime = Date()
        let userTimeZone = TimeZone(secondsFromGMT: Int(userTimeHours * 3600))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = userTimeZone

        let userLocalTime = dateFormatter.string(from: currentTime)
        
        timeLabel.text = userLocalTime
    }
    
    func userCellInit(_ name: String, _ email: String, _ userTime: String, _ imageUrl: String) {
        nameLabel.text = name
        emailLabel.text = email
        
        setupImageView(with: imageUrl)
        setupTimeLabel(with: userTime)
    }
}
