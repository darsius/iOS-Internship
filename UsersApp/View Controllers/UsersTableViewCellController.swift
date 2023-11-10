//
//  UserCell.swift
//  Prob
//
//  Created by Dar Dar on 28.09.2023.
//

import UIKit


class UsersTableViewCellController: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var pictureLabel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
