//
//  LSAddOrderTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/30.
//

import UIKit
import SwifterSwift

class LSAddOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roomView: UIView!
    @IBOutlet weak var roomLab: UITextField!
    
    @IBOutlet weak var projectView: UIView!
    @IBOutlet weak var projectLab: UITextField!
    
    @IBOutlet weak var jsView: UIView!
    @IBOutlet weak var jsPlaceholderLab: UILabel!
    
    
    @IBOutlet weak var jsLab1: UILabel!
    @IBOutlet weak var jsLab2: UILabel!
    @IBOutlet weak var jsLab3: UILabel!
    @IBOutlet weak var jsLabView1: UIView!
    @IBOutlet weak var jsLabView2: UIView!
    @IBOutlet weak var jsLabView3: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.jsLabView1.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView1.borderWidth = 1
        self.jsLabView2.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView2.borderWidth = 1
        self.jsLabView3.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView3.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
