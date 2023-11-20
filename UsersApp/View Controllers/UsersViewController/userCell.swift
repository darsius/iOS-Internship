//
//  UserCell.swift
//  Prob
//
//  Created by Dar Dar on 28.09.2023.
//

import UIKit


class userCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    //    @IBOutlet var emailLabel: UILabel!
//    @IBOutlet var timeLabel: UILabel!
//
//    @IBOutlet weak var userImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellInit(_ name: String) {
        nameLabel.text = name
    }

}
