//
//  LSOrderSummaryItemCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/5/21.
//

import UIKit

class LSOrderSummaryItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var moneyLab: UILabel!
    
    @IBOutlet weak var countLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
