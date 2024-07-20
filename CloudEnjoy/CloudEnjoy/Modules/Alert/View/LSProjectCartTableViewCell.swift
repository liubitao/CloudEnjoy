//
//  LSProjectCartTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/20.
//

import UIKit

class LSProjectCartTableViewCell: UITableViewCell {

    @IBOutlet weak var projectNameLab: UILabel!
    @IBOutlet weak var jsNameLab: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
