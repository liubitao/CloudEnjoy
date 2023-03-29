//
//  LSRankTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/27.
//

import UIKit

class LSRankTableViewCell: UITableViewCell {
    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var ranLab: UILabel!
    @IBOutlet weak var rankIconImageView: UIImageView!
    @IBOutlet weak var rankNameLab: UILabel!
    @IBOutlet weak var rankCodeLab: UILabel!
    @IBOutlet weak var rankClockLab: UILabel!
    @IBOutlet weak var rankLevelLab: UILabel!
    @IBOutlet weak var rankLevelView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
