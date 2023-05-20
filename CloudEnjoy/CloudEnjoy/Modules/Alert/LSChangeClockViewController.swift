//
//  LSChangeClockViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/8.
//

import UIKit
import RxSwift
import RxGesture
import LSBaseModules

class LSChangeClockViewController: LSBaseViewController {
    @IBOutlet weak var oldProjectPicIamgeView: UIImageView!
    @IBOutlet weak var oldProjectNameLab: UILabel!
    @IBOutlet weak var oldProjectPriceLab: UILabel!
    @IBOutlet weak var oldProjectDurationLab: UILabel!
    @IBOutlet weak var newProjectPicIamgeView: UIImageView!
    @IBOutlet weak var newProjectNameLab: UILabel!
    @IBOutlet weak var newProjectPriceLab: UILabel!
    @IBOutlet weak var newProjectDurationLab: UILabel!
    @IBOutlet weak var addTipLab: UILabel!
    @IBOutlet weak var roomNameLab: UILabel!
    @IBOutlet weak var bedNoTitleLab: UILabel!
    @IBOutlet weak var bedNoLab: UILabel!
    @IBOutlet weak var refNameLab: UILabel!
    @IBOutlet weak var selectedProjectView: UIView!

    @IBOutlet weak var refNameView: UIView!
    var projectModel: LSHomeProjectModel!
    
    var newOrderProjectModel: LSOrderProjectModel?
    
    var referrerModel: LSSysUserModel!
    class func creaeFromStoryboard(with projectModel: LSHomeProjectModel) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSChangeClockViewController") as! Self
        vc.projectModel = projectModel
        vc.referrerModel = LSSysUserModel(userid: projectModel.refid, name: projectModel.refname, jobid: projectModel.jobid, tlid: projectModel.reftlid)
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
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 549 + UI.BOTTOM_HEIGHT);
        
        self.oldProjectPicIamgeView.kf.setImage(with: imgUrl(self.projectModel.images))
        self.oldProjectNameLab.text = self.projectModel.projectname
        self.oldProjectPriceLab.text = "￥" + self.projectModel.jprice.stringValue(retain: 2)
        self.oldProjectDurationLab.text = "/" + self.projectModel.jmin + "分钟"
        
        self.roomNameLab.text = self.projectModel.roomname
        self.bedNoTitleLab.text = parametersModel().OperationMode == 0 ? "床位号" : "手牌号"
        self.bedNoLab.text = parametersModel().OperationMode == 0 ? "\(projectModel.bedname)" : "\(projectModel.handcardno)"
        self.refNameLab.text = self.referrerModel.name
        
        self.selectedProjectView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let chioceProjectVC = LSChioceProjectViewController.creaeFromStoryboard(with: self.newOrderProjectModel)
            chioceProjectVC.selectedClosure = { projectModel in
                self.newOrderProjectModel = projectModel
                self.newProjectPicIamgeView.isHidden = false
                self.newProjectNameLab.isHidden = false
                self.newProjectPriceLab.isHidden = false
                self.newProjectDurationLab.isHidden = false
                self.addTipLab.isHidden = true
                self.newProjectPicIamgeView.kf.setImage(with: imgUrl(projectModel.images))
                self.newProjectNameLab.text = projectModel.name
                self.newProjectPriceLab.text = "￥" + projectModel.lprice.stringValue(retain: 2)
                self.newProjectDurationLab.text = "/" + projectModel.smin + "分钟"
            }
            chioceProjectVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        self.refNameView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let referrerVC = LSReferrerViewController.creaeFromStoryboard(with: self.referrerModel)
            referrerVC.referrerModel = self.referrerModel
            referrerVC.selectedClosure = { referrerModel in
                self.referrerModel = referrerModel
                self.refNameLab.text = referrerModel.name
            }
            referrerVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
    }

    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let orderProjectModel = self.newOrderProjectModel else {
            Toast.show("请选择更换的新项目")
            return
        }
        guard self.referrerModel.userid.isEmpty == false else {
            Toast.show("请选择推荐人")
            return
        }
        Toast.showHUD()
        LSHomeServer.updateProject(billid: self.projectModel.billid, roomid: self.projectModel.roomid, roomname: self.projectModel.roomname, handcardid: self.projectModel.handcardid, handcardno: self.projectModel.handcardno, bedid: self.projectModel.bedid, bedname: self.projectModel.bedname, projectid: orderProjectModel.projectid, projectname: orderProjectModel.name, min: orderProjectModel.smin, refid: self.referrerModel.userid, refname: self.referrerModel.name, refjobid: self.referrerModel.jobid)
            .subscribe { _ in
                Toast.show("项目已更换成功")
                self.dismiss(animated: true)
            } onFailure: { error in
                Toast.show(error.localizedDescription)
            } onDisposed: {
                Toast.hiddenHUD()
            }.disposed(by: self.rx.disposeBag)
    }

}
