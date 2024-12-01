import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let nameLb = UILabel()
    private let emailLb = UILabel()
    private let timeLb = UILabel()
    
    private var imageTopConstraint: NSLayoutConstraint?
    private var imageLeftConstraint: NSLayoutConstraint?
    private var imageCenterConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    private var imageWidthConstraint: NSLayoutConstraint?
    
    private var nameLbRightConstraint: NSLayoutConstraint?
    private var nameLbBelowConstraint: NSLayoutConstraint?
    private var nameLbCenterConstraint: NSLayoutConstraint?
    
    private var emailLbRightConstraint: NSLayoutConstraint?
    private var emailLbBelowConstraint: NSLayoutConstraint?
    
    private var timeLbRightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        nameLb.textAlignment = .left
        nameLb.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLb.textColor = .black
        contentView.addSubview(nameLb)
        
        emailLb.textAlignment = .left
        emailLb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        emailLb.textColor = .gray
        contentView.addSubview(emailLb)
        
        timeLb.textAlignment = .right
        timeLb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        timeLb.textColor = .gray
        contentView.addSubview(timeLb)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLb.translatesAutoresizingMaskIntoConstraints = false
        emailLb.translatesAutoresizingMaskIntoConstraints = false
        timeLb.translatesAutoresizingMaskIntoConstraints = false
        
        imageTopConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
        imageLeftConstraint = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        imageCenterConstraint = imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 40)
        imageWidthConstraint =  imageView.widthAnchor.constraint(equalToConstant: 40)
        
        nameLbRightConstraint = nameLb.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        nameLbBelowConstraint = nameLb.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30)
        nameLbCenterConstraint = nameLb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        
        emailLbRightConstraint = emailLb.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        emailLbBelowConstraint = emailLb.topAnchor.constraint(equalTo: nameLb.bottomAnchor, constant: 4)
        
        timeLbRightConstraint = timeLb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
            imageTopConstraint!,
            imageHeightConstraint!,
            imageWidthConstraint!,
            nameLbRightConstraint!,
            nameLb.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            emailLbRightConstraint!,
            emailLbBelowConstraint!,
            timeLbRightConstraint!,
            timeLb.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        imageLeftConstraint?.isActive = true
        imageCenterConstraint?.isActive = false
        nameLbCenterConstraint?.isActive = false
        nameLbBelowConstraint?.isActive = false
    }
    
    private func setupImageView(with urlString: String) {
        imageView.downloaded(from: urlString) { result in
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
                let defaultImage = UIImage(systemName: "person.fill")
                DispatchQueue.main.async {
                    self.imageView.image = defaultImage
                }
            }
        }
    }
    
    private func setupTimeLabel(with userTime: String) {
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
        
        timeLb.text = userLocalTime
    }
    
    func configure(for isGridView: Bool, user: User) {
        
        if isGridView {
            imageLeftConstraint?.isActive = false
            imageCenterConstraint?.isActive = true
            imageTopConstraint?.constant = 20
            imageHeightConstraint?.constant = 100
            imageWidthConstraint?.constant = 100
        } else {
            imageCenterConstraint?.isActive = false
            imageLeftConstraint?.isActive = true
            imageTopConstraint?.constant = 4
            imageHeightConstraint?.constant = 40
            imageWidthConstraint?.constant = 40
        }
        
        imageTopConstraint?.isActive = true
        imageHeightConstraint?.isActive = true
        imageWidthConstraint?.isActive = true
        
        nameLbRightConstraint?.isActive = !isGridView
        nameLbBelowConstraint?.isActive = isGridView
        nameLbCenterConstraint?.isActive = isGridView
        
        emailLbRightConstraint?.isActive = !isGridView
        emailLbBelowConstraint?.isActive = !isGridView
        emailLb.isHidden = isGridView
        
        timeLbRightConstraint?.isActive = !isGridView
        timeLb.isHidden = isGridView
        
        let cornerRadius = isGridView ? 50.0 : 20.0
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        
        setupImageView(with: user.picture.medium)
        setupTimeLabel(with: user.location.timezone.offset)
        nameLb.text = isGridView ? "\(user.name.first)" : "\(user.name.first) \(user.name.last)"
        emailLb.text = user.email
        
        nameLb.textAlignment = isGridView ? .center : .left
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
