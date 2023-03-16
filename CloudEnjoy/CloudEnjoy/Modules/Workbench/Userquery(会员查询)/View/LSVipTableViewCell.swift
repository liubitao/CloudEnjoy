//
//  LSVipTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/13.
//

import UIKit

class LSVipTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLab: UILabel!
    
    @IBOutlet weak var expireLab: UILabel!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var integralLab: UILabel!
    
    @IBOutlet weak var balanceLab: UILabel!
    
    @IBOutlet weak var vipLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
