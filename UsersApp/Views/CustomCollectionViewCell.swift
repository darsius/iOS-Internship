import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let nameLb = UILabel()
    private let emailLb = UILabel()
    private let timeLb = UILabel()
    
    private var constraintsForListView: [NSLayoutConstraint] = []
    private var constraintsForGridView: [NSLayoutConstraint] = []
    
    
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
        imageView.layer.masksToBounds = true
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
        
        constraintsForListView = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            
            nameLb.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLb.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            
            emailLb.topAnchor.constraint(equalTo: nameLb.bottomAnchor, constant: 4),
            emailLb.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            
            timeLb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            timeLb.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ]
        
        constraintsForGridView = [
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLb.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
        ]
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
            guard let formattedTime = formatUserTime(userTime) else {
                timeLb.text = "--:--"
                return
            }
            timeLb.text = formattedTime
        }
        
    private func formatUserTime(_ userTime: String) -> String? {
        let components = userTime.split(separator: ":")
        
        guard components.count == 2,
              let hours = Double(components[0]),
              let minutes = Double(components[1])
        else { return nil }
        
        let userTimeHours = hours + (minutes / 60)
        let currentTime = Date()
        let userTimeZone = TimeZone(secondsFromGMT: Int(userTimeHours * 3600))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = userTimeZone
        
        return dateFormatter.string(from: currentTime)
    }
    
    func configure(for isGridView: Bool, user: User) {
        
        NSLayoutConstraint.deactivate(isGridView ? constraintsForListView : constraintsForGridView)
        NSLayoutConstraint.activate(isGridView ? constraintsForGridView : constraintsForListView)
        
        setupImageView(with: user.picture.medium)
        
        nameLb.text = isGridView ? "\(user.name.first)" : "\(user.name.first) \(user.name.last)"
        nameLb.textAlignment = isGridView ? .center : .left

        emailLb.text = user.email
        emailLb.isHidden = isGridView
        
        setupTimeLabel(with: user.location.timezone.offset)
        timeLb.isHidden = isGridView
        
        imageView.layer.cornerRadius = isGridView ? 50.0 : 20.0
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
