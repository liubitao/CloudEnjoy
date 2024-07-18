//
//  LSGoodsTypeTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/7.
//

import UIKit

class LSProjectTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
