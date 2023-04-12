//
//  LSHomeProjectCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/4.
//

import UIKit
import SwifterSwift

class LSHomeProjectCell: UITableViewCell {
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLab: UILabel!
    
    @IBOutlet weak var roomNameLab: UILabel!
    @IBOutlet weak var projectNameLab: UILabel!
    
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLab: UILabel!
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    func setupViews() {
        self.statusView.cornerRadius = 3
        
        self.durationView.cornerRadius = 3
        self.durationView.borderColor = UIColor(hexString: "#00AEB1")
        self.durationView.borderWidth = 1
        
        self.typeView.cornerRadius = 3
        self.typeView.borderColor = UIColor(hexString: "#00AEB1")
        self.typeView.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
