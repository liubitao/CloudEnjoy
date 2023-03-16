//
//  LSClockTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/13.
//

import UIKit

class LSClockTableViewCell: UITableViewCell {

    @IBOutlet weak var clockTitleLab: UILabel!
    
    @IBOutlet weak var wheelClockLab: UILabel!
    @IBOutlet weak var oClockLab: UILabel!
    @IBOutlet weak var callClockLab: UILabel!
    @IBOutlet weak var optionClockLab: UILabel!
    @IBOutlet weak var addClockLab: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
