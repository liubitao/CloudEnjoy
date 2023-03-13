//
//  LSMineHeadView.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/2.
//

import UIKit
import SwifterSwift
import Kingfisher
import LSBaseModules

class LSMineHeadView: UIView {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    class func createFromXib() -> Self {
        let view = Bundle.main.loadNibNamed("LSMineHeadView", owner: nil)?.last
        return view as! Self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    func setupViews() {
        self.backImageView.image = UIImage.createGradientImage(startColor: Color(hexString: "#00AAB7")!, endColor: Color(hexString: "#00C294")!, width: UI.SCREEN_WIDTH, height: UI.STATUS_NAV_BAR_HEIGHT + 120, isTopToBottom: false)
        [self.userIconImageView, self.userNameLabel, self.phoneLabel].forEach { view in
            view?.isUserInteractionEnabled = true
            view?.rx.tapGesture().subscribe(onNext: { [weak self] element in
                self?.jumpUserInfo(element)
            }).disposed(by: self.rx.disposeBag)
        }
        self.refreshUI()
    }
    
    func refreshUI() {
        self.userIconImageView.kf.setImage(with: imgUrl(userModel().headimg))
        self.userNameLabel.text = "\(userModel().name)(\(userModel().code))"
        self.phoneLabel.text = "\(userModel().mobile.prefix(3))****\(userModel().mobile.suffix(3))"
    }
    
    @IBAction func jumpUserInfo(_ sender: Any) {
        self.viewContainingController()?.navigationController?.pushViewController(LSUserInfoViewController(), animated: true)
    }
    
    
}
