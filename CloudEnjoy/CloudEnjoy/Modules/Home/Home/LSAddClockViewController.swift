//
//  LSAddClockViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/5/21.
//

import UIKit
import LSBaseModules

class LSAddClockViewController: LSBaseViewController {
    @IBOutlet weak var oldProjectPicIamgeView: UIImageView!
    @IBOutlet weak var oldProjectNameLab: UILabel!
    @IBOutlet weak var oldProjectPriceLab: UILabel!
    @IBOutlet weak var oldProjectDurationLab: UILabel!
    @IBOutlet weak var newProjectPicIamgeView: UIImageView!
    @IBOutlet weak var newProjectNameLab: UILabel!
    @IBOutlet weak var newProjectPriceLab: UILabel!
    @IBOutlet weak var newProjectDurationLab: UILabel!
    
    @IBOutlet weak var roomTitleLab: UILabel!
    @IBOutlet weak var roomNameLab: UILabel!
    @IBOutlet weak var refNameLab: UILabel!
    @IBOutlet weak var selectedProjectView: UIView!

    @IBOutlet weak var refNameView: UIView!
    
    @IBOutlet weak var numberLab: UILabel!
    
    @IBOutlet weak var subtractBtn: UIButton!
    
    @IBOutlet weak var plusBtn: UIButton!
    
    var projectModel: LSHomeProjectModel!
    var newOrderProjectModel: LSOrderProjectModel?
    
    var referrerModel: LSSysUserModel = LSSysUserModel()

    
    convenience init(with projectModel: LSHomeProjectModel){
        self.init()
        self.projectModel = projectModel
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "项目加钟"
    }
    
    override func setupViews() {
        self.oldProjectPicIamgeView.kf.setImage(with: imgUrl(self.projectModel.images))
        self.oldProjectNameLab.text = self.projectModel.projectname
        self.oldProjectPriceLab.text = "￥" + self.projectModel.jprice.stringValue(retain: 2)
        self.oldProjectDurationLab.text = "/" + self.projectModel.jmin + "分钟"
        
        self.newOrderProjectModel = LSOrderProjectModel(name: self.projectModel.name, projectid: self.projectModel.projectid)
        self.newProjectPicIamgeView.kf.setImage(with: imgUrl(self.projectModel.images))
        self.newProjectNameLab.text = self.projectModel.projectname
        self.newProjectPriceLab.text = "￥" + self.projectModel.jprice.stringValue(retain: 2)
        self.newProjectDurationLab.text = "/" + self.projectModel.jmin + "分钟"
        
        self.numberLab.text = parametersModel().addClockDefTime.floorString(retain: 1)
        
        var roomDetailsStr = ""
        switch parametersModel().OperationMode {
        case .roomAndBed:
            self.roomTitleLab.text = "房间号"
            roomDetailsStr = projectModel.roomname + "(床位：\(projectModel.bedname))"
        case .roomAndHandCard:
            self.roomTitleLab.text = "房间号"
            roomDetailsStr = projectModel.roomname + "(手牌：\(projectModel.handcardno))"
        case .handCard:
            self.roomTitleLab.text = "手牌号"
            roomDetailsStr = projectModel.handcardno
        }
        self.roomNameLab.text = roomDetailsStr
        
        self.referrerModel = LSSysUserModel(userid: userModel().userid, name: userModel().name)
        self.refNameLab.text = self.referrerModel.name
        
        self.selectedProjectView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let chioceProjectVC = LSChioceProjectViewController.creaeFromStoryboard(with: self.newOrderProjectModel, tid: self.projectModel.tid)
            chioceProjectVC.selectedClosure = { projectModel in
                self.newOrderProjectModel = projectModel
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
    
    @IBAction func subtractAction(_ sender: Any) {
        let defTime = parametersModel().addClockDefTime
        guard let number = self.numberLab.text?.double(),
              number > defTime else {
            return
        }
        self.numberLab.text = (number - defTime).string
    }
    
    
    @IBAction func plusAction(_ sender: Any) {
        let defTime = parametersModel().addClockDefTime
        guard let number = self.numberLab.text?.double() else {
            return
        }
        self.numberLab.text = (number + defTime).string
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let number = self.numberLab.text?.double() else {
            Toast.show("请添加您想加钟的次数")
            return
        }
        guard let newprojectModel = self.newOrderProjectModel else {
            Toast.show("请添加您想加钟的项目")
            return
        }
        Toast.showHUD()
        LSHomeServer.addClock(billid: self.projectModel.billid, projectid: newprojectModel.projectid, qty: number.string, refid: self.referrerModel.userid, refname: self.referrerModel.name)
            .subscribe { _ in
                Toast.show("已加钟成功")
                self.navigationController?.popViewController(animated: true)
            } onFailure: { error in
                Toast.show(error.localizedDescription)
            } onDisposed: {
                Toast.hiddenHUD()
            }.disposed(by: self.rx.disposeBag)
    }
    

}
