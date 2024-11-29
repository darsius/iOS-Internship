import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    //    private var userImageView: UIImageView
    
    private let imageView = UIImageView()
    private let nameLb = UILabel()
    private let emailLb = UILabel()
    private let timeLb = UILabel()
    
    private var imageLeftConstraint: NSLayoutConstraint?
    private var imageCenterConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    private var imageWidthConstraint: NSLayoutConstraint?
    
    private var nameLbRightConstraint: NSLayoutConstraint?
    private var nameLbBelowConstraint: NSLayoutConstraint?
    private var nameLbCenterConstraint: NSLayoutConstraint?
    
    private var emailLbRightConstraint: NSLayoutConstraint?
    private var emailLbBelowConstraint: NSLayoutConstraint?
    //    private var emailLbCenterConstraint: NSLayoutConstraint?
    
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
        //        imageView.layer.cornerRadius = 10
        //        imageView.layer.masksToBounds = true
        //        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        nameLb.textAlignment = .left
        nameLb.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLb.textColor = .black
        contentView.addSubview(nameLb)
        
        emailLb.textAlignment = .left
        emailLb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        emailLb.textColor = .gray
        contentView.addSubview(emailLb)
        
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLb.translatesAutoresizingMaskIntoConstraints = false
        emailLb.translatesAutoresizingMaskIntoConstraints = false
        
        imageLeftConstraint = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        imageCenterConstraint = imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 40)
        imageWidthConstraint =  imageView.widthAnchor.constraint(equalToConstant: 40)
        
        nameLbRightConstraint = nameLb.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        nameLbBelowConstraint = nameLb.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40)
        nameLbCenterConstraint = nameLb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        
        emailLbRightConstraint = emailLb.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        emailLbBelowConstraint = emailLb.topAnchor.constraint(equalTo: nameLb.bottomAnchor, constant: 4)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageHeightConstraint!,
            imageWidthConstraint!,
            //                imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            //                imageView.heightAnchor.constraint(equalToConstant: 40),
            imageLeftConstraint!, // Activate leading alignment initially
            nameLbRightConstraint!, // Activate name label to the right of image
            nameLb.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20), // Ensure label stays within bounds
            emailLbRightConstraint!, // Activate email label to the right of image
            emailLbBelowConstraint! // Position email label below name label
        ])
        
        // Deactivate unused constraints
        imageCenterConstraint?.isActive = false
        nameLbCenterConstraint?.isActive = false
        nameLbBelowConstraint?.isActive = false
    }
    
    func setupImageView(with urlString: String) {
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
        //        print(imageView.frame.size.height / 2)
        //        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        //        imageView.layer.masksToBounds = true
    }
    
    func configure(for isGridView: Bool, user: User) {
        
        imageLeftConstraint?.isActive = !isGridView
        imageCenterConstraint?.isActive = isGridView
        imageHeightConstraint?.isActive = !isGridView
        imageWidthConstraint?.isActive = !isGridView
        
        nameLbRightConstraint?.isActive = !isGridView
        nameLbBelowConstraint?.isActive = isGridView
        nameLbCenterConstraint?.isActive = isGridView
        
        emailLbRightConstraint?.isActive = !isGridView
        emailLbBelowConstraint?.isActive = !isGridView
        emailLb.isHidden = isGridView
        
        let cornerRadius = isGridView ? 36.0 : 20.0
        
        //        print(imageView.frame.size.height / 2)
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        
        setupImageView(with: user.picture.medium)
        nameLb.text = "\(user.name.first) \(user.name.last)"
        emailLb.text = user.email
        
        nameLb.textAlignment = isGridView ? .center : .left
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
