//
//  LSClockInTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/14.
//

import UIKit
import SwifterSwift

class LSClockInTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var upLineView: UIView!
    @IBOutlet weak var downLineView: UIView!
    @IBOutlet weak var clockTimeLab: UILabel!
    @IBOutlet weak var clockAddressLab: UILabel!
    @IBOutlet weak var clockLeftView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setupViews()
    }
    
    func setupViews() {
        self.clockLeftView.cornerRadius = 4
        self.clockLeftView.borderWidth = 1
        self.clockLeftView.borderColor = Color(hexString: "#EF9C00")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
