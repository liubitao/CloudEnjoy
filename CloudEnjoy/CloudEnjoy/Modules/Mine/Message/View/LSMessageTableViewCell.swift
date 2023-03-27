//
//  LSMessageTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/27.
//

import UIKit
import SwifterSwift

class LSMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var selectedBtn: UIButton!
    
    @IBOutlet weak var msgContentView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    
    var isEdit = false
    
    var shapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func refreshUI() {
        self.shapeLayer.removeFromSuperlayer()
        self.drawDashLine(lineLength: 2, lineSpacing: 2, lineColor: Color(hexString: "#707070")!)
    }
    
    func drawDashLine(lineLength: Int, lineSpacing: Int, lineColor : UIColor, lineWidth: CGFloat = 1){
        self.shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        let path = CGMutablePath()
        path.move(to: CGPoint(x: self.isEdit ? 35 : 15, y: 40))
        path.addLine(to: CGPoint(x: self.bounds.size.width - 15 , y: 40))
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    @IBAction func selectedAction(_ sender: Any) {
        self.selectedBtn.isSelected = !self.selectedBtn.isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
