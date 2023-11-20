//
//  TitleView.swift
//  UsersApp
//
//  Created by Dar Dar on 19.11.2023.
//

import UIKit

class TitleView: UIView {

    @IBOutlet weak var titleView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubView()    }
    
    private func initSubView() {
        let xibView = Bundle.main.loadNibNamed("TitleView", owner: self, options: nil)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
}
