//
//  HeaderView.swift
//  UsersApp
//
//  Created by Dar Dar on 14.10.2024.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    static let identifier = "header"

    override func awakeFromNib() {
        super.awakeFromNib()
        segmentControl.addTarget(self,
                                 action: #selector(segmentControlChanged(_:)),
                                 for: .valueChanged)
    }
    
    @objc private func segmentControlChanged(_ sender: UISegmentedControl) {
        NotificationCenter.default.post(name: .segmentControlChanged, object: sender.selectedSegmentIndex)
    }
}
