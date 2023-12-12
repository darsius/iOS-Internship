//
//  UserCell.swift
//  Prob
//
//  Created by Dar Dar on 28.09.2023.
//

import UIKit


class UserCellView: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupImageView(with urlString: String) {
            userImageView.downloaded(from: urlString, contentMode: .scaleToFill)
            userImageView.layer.cornerRadius = userImageView.frame.size.height / 2
            userImageView.layer.masksToBounds = true
        }
    
    func setupTimeLabel(with userTime: String) {
            let components = userTime.split(separator: ":")

            guard components.count == 2,
                  let hours = Double(components[0]),
                  let minutes = Double(components[1])
            else {
                fatalError("invalid time as string")
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
