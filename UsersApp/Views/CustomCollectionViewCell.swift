import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    private var imageLeftConstraint: NSLayoutConstraint?
    private var imageCenterConstraint: NSLayoutConstraint?
    private var labelRightConstraint: NSLayoutConstraint?
    private var labelBelowConstraint: NSLayoutConstraint?
    private var labelCenterConstraint: NSLayoutConstraint?

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

        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        imageLeftConstraint = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        imageCenterConstraint = imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)

        labelRightConstraint = titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        labelBelowConstraint = titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        labelCenterConstraint = titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        ])

        imageLeftConstraint?.isActive = true
        labelRightConstraint?.isActive = true
    }
    

    func configure(for isGridView: Bool, image: UIImage?, title: String) {
        imageView.image = image
        titleLabel.text = title

        imageLeftConstraint?.isActive = !isGridView
        imageCenterConstraint?.isActive = isGridView
        labelRightConstraint?.isActive = !isGridView
        labelBelowConstraint?.isActive = isGridView
        labelCenterConstraint?.isActive = isGridView

        titleLabel.textAlignment = isGridView ? .center : .left

        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
