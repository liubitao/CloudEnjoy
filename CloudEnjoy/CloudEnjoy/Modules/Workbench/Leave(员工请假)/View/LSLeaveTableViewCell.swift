//
//  LSLeaveTableViewCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/28.
//

import UIKit
import SwifterSwift

class LSLeaveTableViewCell: UITableViewCell {

    @IBOutlet weak var leaveTypeLab: UILabel!
    @IBOutlet weak var startTimeLab: UILabel!
    @IBOutlet weak var endTimeLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        setupViews()
    }
    func setupViews() {
        self.drawDashLine(lineLength: 2, lineSpacing: 2, lineColor: Color(hexString: "#707070")!)
    }
    func drawDashLine(lineLength: Int, lineSpacing: Int, lineColor : UIColor, lineWidth: CGFloat = 1){
           let shapeLayer = CAShapeLayer()
           shapeLayer.bounds = self.bounds
           shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
           shapeLayer.strokeColor = lineColor.cgColor
           shapeLayer.lineWidth = lineWidth
           shapeLayer.lineJoin = CAShapeLayerLineJoin.round
           shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
           let path = CGMutablePath()
           path.move(to: CGPoint(x: 15, y: 37))
           path.addLine(to: CGPoint(x: self.bounds.size.width - 30, y: 37))
           shapeLayer.path = path
           self.layer.addSublayer(shapeLayer)
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
