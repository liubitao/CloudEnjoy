//
//  LSJSTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/18.
//

import UIKit

class LSJSTableViewCell: UITableViewCell {

    @IBOutlet weak var jsImgView: UIImageView!
    @IBOutlet weak var jsNoLab: UILabel!

    @IBOutlet weak var jsNameLab: UILabel!
    
    @IBOutlet weak var jslevelLab: UILabel!
    
    @IBOutlet weak var selectImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
