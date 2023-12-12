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
        guard let xibTitleView = Bundle.main.loadNibNamed("TitleView", owner: self, options: nil)?.first as? UIView else {
            print("Error at loading TitleView!")
            return
        }

        xibTitleView.frame = bounds
        xibTitleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibTitleView)

    }
}
