//
//  LSBindhandCardViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2025/8/6.
//

import UIKit

class LSBindhandCardViewController: LSBaseViewController {
    @IBOutlet weak var roomNameLab: UILabel!
    
    @IBOutlet weak var projectNameLab: UILabel!
    
    @IBOutlet weak var hardNoLab: UILabel!
    
    @IBOutlet weak var hardNoView: UIView!
    
    var projectModel: LSHomeProjectModel!
    var handCardModel: LSHandCardModel?
    
    convenience init(with projectModel: LSHomeProjectModel) {
        self.init()
        self.projectModel = projectModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupViews() {
        self.title = "绑定手牌"
        self.roomNameLab.text = self.projectModel.roomname
        self.projectNameLab.text = self.projectModel.projectname
        
        self.hardNoView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let chioceHandCardVC = LSHandCardChioceAlertViewController.creaeFromStoryboard(handCardModel: self.handCardModel)
            chioceHandCardVC.selectedClosure = { handCardModel in
                self.handCardModel = handCardModel
                self.hardNoLab.text = handCardModel.handcardno
            }
            chioceHandCardVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let handCardModel = self.handCardModel else {
            Toast.show("请选择手牌")
            return
        }
        
        Toast.showHUD()
        LSHomeServer.bindHandcard(billid: self.projectModel.billid,
                                  roomid: self.projectModel.roomid,
                                  handcardid: handCardModel.handcardid,
                                  handcardno: handCardModel.handcardno)
        .subscribe { _ in
            self.navigationController?.popToRootViewController(animated: true)
            Toast.show("手牌绑定成功")
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }


}
