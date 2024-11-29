import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLb = UILabel()
    private let emailLb = UILabel()
    private let timeLb = UILabel()

    private var imageLeftConstraint: NSLayoutConstraint?
    private var imageCenterConstraint: NSLayoutConstraint?
    
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
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
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
        
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLb.translatesAutoresizingMaskIntoConstraints = false
        emailLb.translatesAutoresizingMaskIntoConstraints = false

        imageLeftConstraint = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        imageCenterConstraint = imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)

        nameLbRightConstraint = nameLb.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        nameLbBelowConstraint = nameLb.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        nameLbCenterConstraint = nameLb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        
        emailLbRightConstraint = emailLb.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        emailLbBelowConstraint = emailLb.topAnchor.constraint(equalTo: nameLb.bottomAnchor, constant: 4)
        

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            
            nameLb.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20)
            
//            emailLb.
        ])

        imageLeftConstraint?.isActive = true
        nameLbRightConstraint?.isActive = true
        emailLbRightConstraint?.isActive = true
        emailLbBelowConstraint?.isActive = true
    }
    

    func configure(for isGridView: Bool, image: UIImage?, title: String) {
        imageView.image = image
        nameLb.text = title
        emailLb.text = "a@aaaa.com"

        imageLeftConstraint?.isActive = !isGridView
        imageCenterConstraint?.isActive = isGridView
        
        nameLbRightConstraint?.isActive = !isGridView
        nameLbBelowConstraint?.isActive = isGridView
        nameLbCenterConstraint?.isActive = isGridView
        
        emailLbRightConstraint?.isActive = !isGridView
        emailLbBelowConstraint?.isActive = !isGridView
        emailLb.isHidden = isGridView

        nameLb.textAlignment = isGridView ? .center : .left

        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
