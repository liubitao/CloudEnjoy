//
//  LSGoodsTypeTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/7.
//

import UIKit

class LSGoodsTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var numberView: UIView!
    
    @IBOutlet weak var numberLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
