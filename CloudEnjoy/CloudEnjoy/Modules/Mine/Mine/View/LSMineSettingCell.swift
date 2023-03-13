//
//  LSMineSettingCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit

class LSMineSettingCell: UITableViewCell {
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var settingTitleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func refreshUI(_ settingIconName: String, _ settingTitle: String) {
        self.settingImageView.image = UIImage(named: settingIconName)
        self.settingTitleLab.text = settingTitle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
