//
//  LSWorkbenchViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/2.
//

import Foundation
import UIKit
import SwifterSwift

class LSWorkbenchViewController: LSBaseViewController {
    @IBOutlet weak var headBackImageView: UIImageView!
    @IBOutlet weak var headBackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vhl_navBarBackgroundAlpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vhl_navBarBackgroundAlpha = 1
    }
    
    override func setupViews() {
        self.headBackImageView.image = UIImage.createGradientImage(startColor: Color(hexString: "#00AAB7")!, endColor: Color(hexString: "#00C294")!, width: UI.SCREEN_WIDTH, height: UI.STATUS_NAV_BAR_HEIGHT + 73, isTopToBottom: false)
        self.headBackHeight.constant = UI.STATUS_NAV_BAR_HEIGHT + 73
        
        [btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8].forEach { btn in
            btn?.centerTextAndImage(imageAboveText: true, spacing: 5)
        }
    }
    
    @IBAction func jumpRoyalties(_ sender: Any) {
        self.navigationController?.pushViewController(LSRoyaltiesViewController(), animated: true)
    }
    
    @IBAction func jumpClocks(_ sender: Any) {
        self.navigationController?.pushViewController(LSClocksViewController(), animated: true)
    }
    
    @IBAction func jumpWorkorder(_ sender: Any) {
        self.navigationController?.pushViewController(LSWorkorderViewController(), animated: true)
    }
    
    @IBAction func jumpOrderSummary(_ sender: Any) {
        
    }
    
    @IBAction func jumpJsRank(_ sender: Any) {
        
    }
    
    @IBAction func jumpUserquery(_ sender: Any) {
        self.navigationController?.pushViewController(LSUserqueryViewController(), animated: true)
    }
    @IBAction func jumpOrder(_ sender: Any) {
        self.navigationController?.pushViewController(LSOrderViewController(), animated: true)
    }
    @IBAction func jumpAddOrder(_ sender: Any) {
        self.navigationController?.pushViewController(LSAddOrderViewController(), animated: true)
    }
    @IBAction func jumpClockin(_ sender: Any) {
        self.navigationController?.pushViewController(LSClockinViewController(), animated: true)
    }
    @IBAction func jumpLeave(_ sender: Any) {
        self.navigationController?.pushViewController(LSLeaveViewController(), animated: true)
    }
}
