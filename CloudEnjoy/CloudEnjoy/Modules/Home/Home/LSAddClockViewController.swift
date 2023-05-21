//
//  LSAddClockViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/5/21.
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
    
    @IBOutlet weak var referrerView: UIView!
    @IBOutlet weak var referrerLab: UILabel!
    
    
    var projectModel: LSHomeProjectModel!
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
        self.projectPicIamgeView.kf.setImage(with: imgUrl(self.projectModel.images))
        self.projectNameLab.text = self.projectModel.projectname
        self.projectPriceLab.text = "￥" + self.projectModel.jprice.stringValue(retain: 2)
        self.projectDurationLab.text = "/" + self.projectModel.jmin + "分钟"
        self.roomNameLab.text = self.projectModel.roomname
        self.bedNoTitleLab.text = parametersModel().OperationMode == 0 ? "床位号" : "手牌号"
        self.bedNoLab.text = parametersModel().OperationMode == 0 ? "\(projectModel.bedname)" : "\(projectModel.handcardno)"
        
        self.referrerView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let referrerVC = LSReferrerViewController.creaeFromStoryboard(with: self.referrerModel)
            referrerVC.referrerModel = self.referrerModel
            referrerVC.selectedClosure = { referrerModel in
                self.referrerModel = referrerModel
                self.referrerLab.text = referrerModel.name
            }
            referrerVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
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
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                self.navigationController?.popViewController(animated: true)
            } onFailure: { error in
                Toast.show(error.localizedDescription)
            } onDisposed: {
                Toast.hiddenHUD()
            }.disposed(by: self.rx.disposeBag)
    }
    

}
