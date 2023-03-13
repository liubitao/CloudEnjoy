//
//  LSRoyaltiesDetailsCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/11.
//

import UIKit
import SwifterSwift

class LSRoyaltiesDetailsCell: UITableViewCell {

    @IBOutlet weak var projectNameLab: UILabel!
    
    @IBOutlet weak var commissionLab: UILabel!
    
    @IBOutlet weak var roomNameLab: UILabel!
    
    @IBOutlet weak var projectTypeLab: UILabel!
    
    @IBOutlet weak var amtLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
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
           path.move(to: CGPoint(x: 15, y: 40))
           path.addLine(to: CGPoint(x: self.bounds.size.width - 30, y: 40))
           shapeLayer.path = path
           self.layer.addSublayer(shapeLayer)
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
