//
//  LSProjectAddTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/18.
//

import UIKit
import SwifterSwift
import LSBaseModules

class LSProjectAddTableViewCell: UITableViewCell {
    @IBOutlet weak var jsView: UIView!
    @IBOutlet weak var jsPlaceholderLab: UILabel!
    
    @IBOutlet weak var jsLab1: UILabel!
    @IBOutlet weak var jsLab2: UILabel!
    @IBOutlet weak var jsLab3: UILabel!
    @IBOutlet weak var jsLabView1: UIView!
    @IBOutlet weak var jsLabView2: UIView!
    @IBOutlet weak var jsLabView3: UIView!
    
    @IBOutlet weak var bedView: UIView!
    @IBOutlet weak var bedTextField: UITextField!
    
    @IBOutlet weak var handCardView: UIView!
    @IBOutlet weak var handCardTextField: UITextField!
    
    @IBOutlet weak var referrerView: UIView!
    @IBOutlet weak var referrerTextField: UITextField!
    
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var remarkTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.jsLabView1.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView1.borderWidth = 1
        self.jsLabView2.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView2.borderWidth = 1
        self.jsLabView3.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView3.borderWidth = 1
        
        self.bedView.isHidden = parametersModel().OperationMode != .roomAndBed
        self.handCardView.isHidden = parametersModel().OperationMode == .roomAndBed
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
