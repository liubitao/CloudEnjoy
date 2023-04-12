//
//  LSServiceTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/8.
//

import UIKit

class LSServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var serviceNumberLab: UILabel!
    @IBOutlet weak var subtractBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
