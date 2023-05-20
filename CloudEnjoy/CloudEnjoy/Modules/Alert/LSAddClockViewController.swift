//
//  LSAddClockViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/8.
//

import UIKit
import LSBaseModules

class LSAddClockViewController: LSBaseViewController {

    @IBOutlet weak var projectPicIamgeView: UIImageView!
    
    @IBOutlet weak var projectNameLab: UILabel!
    
    @IBOutlet weak var projectPriceLab: UILabel!
    
    @IBOutlet weak var projectDurationLab: UILabel!
    
    @IBOutlet weak var roomNameLab: UILabel!
    
    @IBOutlet weak var bedNoTitleLab: UILabel!
    @IBOutlet weak var bedNoLab: UILabel!
    
    @IBOutlet weak var numberLab: UILabel!
    
    @IBOutlet weak var subtractBtn: UIButton!
    
    @IBOutlet weak var plusBtn: UIButton!

    
    var projectModel: LSHomeProjectModel!
    
    class func creaeFromStoryboard(with projectModel: LSHomeProjectModel) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSAddClockViewController") as! Self
        vc.projectModel = projectModel
        return vc
    }
    
    func presentedWith(_ presentingViewController: LSBaseViewController) {
        let transitionAnimationDelegate = TransitionAnimationDelegate()
        transitionAnimationDelegate.overlayTransitioningType = .blackBackground
        transitionAnimationDelegate.touchInBackgroundType = .close
        transitionAnimationDelegate.viewAnimationType = .transformFromBottom
        transitionAnimationDelegate.enableInteractive = true
        self.transitioningDelegate = transitionAnimationDelegate
        self.modalPresentationStyle = .custom
        presentingViewController.present(self, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.white;
        self.view.cornerRadius = 5
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 370 + UI.BOTTOM_HEIGHT);
        
        self.projectPicIamgeView.kf.setImage(with: imgUrl(self.projectModel.images))
        self.projectNameLab.text = self.projectModel.projectname
        self.projectPriceLab.text = "￥" + self.projectModel.jprice.stringValue(retain: 2)
        self.projectDurationLab.text = "/" + self.projectModel.jmin + "分钟"
        self.roomNameLab.text = self.projectModel.roomname
        self.bedNoTitleLab.text = parametersModel().OperationMode == 0 ? "床位号" : "手牌号"
        self.bedNoLab.text = parametersModel().OperationMode == 0 ? "\(projectModel.bedname)" : "\(projectModel.handcardno)"
    }
    
    @IBAction func subtractAction(_ sender: Any) {
        guard let number = self.numberLab.text?.double(),
              number > 0.5 else {
            return
        }
        self.numberLab.text = (number - 0.5).string
    }
    
    
    @IBAction func plusAction(_ sender: Any) {
        guard let number = self.numberLab.text?.double() else {
            return
        }
        self.numberLab.text = (number + 0.5).string
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let number = self.numberLab.text?.double() else {
            Toast.show("请添加您想加钟的次数")
            return
        }
        Toast.showHUD()
        LSHomeServer.addClock(billid: self.projectModel.billid, projectid: self.projectModel.projectid, qty: number.string)
            .subscribe { _ in
                Toast.show("已加钟成功")
                self.dismiss(animated: true)
            } onFailure: { error in
                Toast.show(error.localizedDescription)
            } onDisposed: {
                Toast.hiddenHUD()
            }.disposed(by: self.rx.disposeBag)
    }
}
