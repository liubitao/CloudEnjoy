//
//  LSJsRankTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/5/21.
//

import UIKit

class LSJsRankTableViewCell: UITableViewCell {
    @IBOutlet weak var rankView: UIView!
    
    @IBOutlet weak var rankLab: UILabel!
    
    @IBOutlet weak var shiftLab: UILabel!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var jobLab: UILabel!
    
    @IBOutlet weak var jobStateLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
