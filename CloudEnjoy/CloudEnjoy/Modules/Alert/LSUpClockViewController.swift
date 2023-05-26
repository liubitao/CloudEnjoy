//
//  LSUpClockViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/7.
//

import UIKit
import SwifterSwift
import LSBaseModules

class LSUpClockViewController: LSBaseViewController {
    @IBOutlet weak var roomNameLab: UILabel!
    
    @IBOutlet weak var waitTimeLab: UILabel!
    
    @IBOutlet weak var projectNameLab: UILabel!
    
    @IBOutlet weak var clockTypeLab: UILabel!
    
    
    weak var presentingController: LSBaseViewController? = nil

    var projectModel: LSHomeProjectModel!
    
    class func creaeFromStoryboard(with projectModel: LSHomeProjectModel) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSUpClockViewController") as! Self
        vc.projectModel = projectModel
        return vc
    }
    
    func presentedWith(_ presentingViewController: LSBaseViewController) {
        let transitionAnimationDelegate = TransitionAnimationDelegate()
        transitionAnimationDelegate.overlayTransitioningType = .blackBackground
        transitionAnimationDelegate.touchInBackgroundType = .close
        transitionAnimationDelegate.viewAnimationType = .alphagGradualChange
        transitionAnimationDelegate.enableInteractive = true
        self.transitioningDelegate = transitionAnimationDelegate
        self.modalPresentationStyle = .custom
        self.presentingController = presentingViewController
        presentingViewController.present(self, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.white;
        self.view.cornerRadius = 5
        self.view.frame = CGRectMake((UI.SCREEN_WIDTH - 290)/2.0, (UI.SCREEN_HEIGHT - 270)/2.0, 290, 270);
        
        self.roomNameLab.text = projectModel.roomname + (parametersModel().OperationMode == 0 ? "(床位号：\(projectModel.bedname))" : "(手牌号：\(projectModel.handcardno))")
        self.projectNameLab.text = projectModel.projectname
        self.waitTimeLab.text = Date().minutesSince(projectModel.dispatchtime.date(withFormat: "yyyy-MM-dd HH:mm:ss") ?? Date()).stringValue(retain: 0) + "分钟"
        self.projectNameLab.text = projectModel.projectname
        self.clockTypeLab.text = projectModel.ctype.clockString
    }
    

    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        Toast.showHUD()
        LSHomeServer.updateClockStatus(billid: self.projectModel.billid, status: "1")
            .subscribe { _ in
                self.dismiss(animated: true) {
                    self.presentingController?.navigationController?.popViewController(animated: true)
                    LSAudioQueueManager.shared.enqueueToQueue(LSAudioOperation(audioName: "本次项目已开始上钟很高兴为您（收银端或技师端点击上钟后提醒）"))
                }
            } onFailure: { error in
                Toast.show(error.localizedDescription)
            } onDisposed: {
                Toast.hiddenHUD()
            }.disposed(by: self.rx.disposeBag)
    }

}
