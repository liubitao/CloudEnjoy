//
//  LSGoodsTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/8.
//

import UIKit

class LSProjectTableViewCell: UITableViewCell {
    @IBOutlet weak var projectPicImageView: UIImageView!
    @IBOutlet weak var projectPriceLab: UILabel!
    @IBOutlet weak var projectNameLab: UILabel!
    @IBOutlet weak var projectDurationLab: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
