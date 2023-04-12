//
//  LSDownClockViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/6.
//

import UIKit

class LSDownClockViewController: LSBaseViewController {

    @IBOutlet weak var roomNameLab: UILabel!
    
    @IBOutlet weak var bedNoLab: UILabel!
    
    @IBOutlet weak var projectNameLab: UILabel!
    
    @IBOutlet weak var clockTypeLab: UILabel!
    
    @IBOutlet weak var upClockLab: UILabel!
    
    @IBOutlet weak var downClockLab: UILabel!
    
    
    weak var presentingController: LSBaseViewController? = nil

    var projectModel: LSHomeProjectModel!

    
    class func creaeFromStoryboard(with projectModel: LSHomeProjectModel) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSDownClockViewController") as! Self
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
        self.view.frame = CGRectMake((UI.SCREEN_WIDTH - 290)/2.0, (UI.SCREEN_HEIGHT - 360)/2.0, 290, 360);
        
        self.roomNameLab.text = projectModel.roomname
        self.bedNoLab.text = projectModel.bedname
        self.projectNameLab.text = projectModel.projectname
        self.clockTypeLab.text = projectModel.ctype.clockString
        self.upClockLab.text = projectModel.starttime
        self.downClockLab.text = Date().string(withFormat: "yyyy-MM-dd hh:mm:ss")
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        Toast.showHUD()
        LSHomeServer.updateClockStatus(billid: self.projectModel.billid, status: "2")
            .subscribe { _ in
                self.dismiss(animated: true) {
                    self.presentingController?.navigationController?.popViewController(animated: true)
                }
            } onFailure: { error in
                Toast.show(error.localizedDescription)
            } onDisposed: {
                Toast.hiddenHUD()
            }.disposed(by: self.rx.disposeBag)
    }
    

}
