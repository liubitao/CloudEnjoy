//
//  LSRoyaltiesItemTableCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/11.
//

import UIKit

class LSRoyaltiesItemTableCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var moneyLab: UILabel!
    
    @IBOutlet weak var countLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
