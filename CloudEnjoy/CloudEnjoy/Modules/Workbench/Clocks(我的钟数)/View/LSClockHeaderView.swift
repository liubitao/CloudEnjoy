//
//  LSClockHeaderView.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/13.
//

import UIKit

class LSClockHeaderView: UIView {

    class func createFromXib() -> Self {
        let view = Bundle.main.loadNibNamed("LSClockHeaderView", owner: nil)?.last
        return view as! Self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    func setupViews() {
        self.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 33)
    }
}
