//
//  UserCell.swift
//  Prob
//
//  Created by Dar Dar on 28.09.2023.
//

import UIKit


class userCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet var emailLabel: UILabel!
//    @IBOutlet var timeLabel: UILabel!
//
    @IBOutlet weak var userImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellInit(_ name: String, _ image: UIImageView, _ email: String, _ time: String) {
        nameLabel.text = name
        emailLabel.text = email
        timeLabel.text = time
        userImage = image
    }
    
//    func imageInit(_ apiData: User) -> UIImageView{
//        let stringUrl = apiData.picture.medium
//
//        let imageView = UIImageView()
////        imageView.downloaded(from: stringUrl, contentMode: .scaleToFill)
////        imageView.layer.cornerRadius = imageView.frame.size.height / 2
////        imageView.layer.masksToBounds = true
////        imageView.layer.borderWidth = 2.0
////        imageView.layer.borderColor = UIColor.blue.cgColor
//
//        return imageView
//    }
        
}
