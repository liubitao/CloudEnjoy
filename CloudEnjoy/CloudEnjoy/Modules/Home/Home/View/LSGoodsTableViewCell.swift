//
//  LSGoodsTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/8.
//

import UIKit

class LSGoodsTableViewCell: UITableViewCell {
    @IBOutlet weak var goodsPicImageView: UIImageView!
    @IBOutlet weak var goodsPriceLab: UILabel!
    @IBOutlet weak var goodsNameLab: UILabel!
    @IBOutlet weak var goodsStockLab: UILabel!
    @IBOutlet weak var goodsNumberLab: UILabel!
    @IBOutlet weak var subtractBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func subtractAction(_ sender: Any) {
        
    }
    
    @IBAction func plusAction(_ sender: Any) {
    }
    
    
}
