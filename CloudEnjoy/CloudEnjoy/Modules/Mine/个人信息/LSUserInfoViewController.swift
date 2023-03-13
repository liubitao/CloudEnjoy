//
//  LSUserInfoViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/10.
//

import UIKit
import LSBaseModules
import AnyImageKit
import RxSwift
import LSNetwork
import SwifterSwift

class LSUserInfoViewController: LSBaseViewController {

    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var accountLab: UILabel!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var sexLab: UILabel!
    
    @IBOutlet weak var numberLab: UILabel!
    
    @IBOutlet weak var levelLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
    }
    override func setupViews() {
        self.iconImageView.kf.setImage(with: imgUrl(userModel().headimg))
        self.accountLab.text = userModel().mobile
        self.nameLab.text = userModel().name
        self.sexLab.text = userModel().sex.text
        self.numberLab.text = userModel().code
        self.levelLab.text = userModel().tlname
        
        self.iconImageView.rx.tapGesture().when(.recognized).subscribe {[weak self] _ in
            guard let self = self else {return}
            var options = PickerOptionsInfo()
            options.selectLimit = 1
            let controller = ImagePickerController(options: options, delegate: self)
            self.present(controller, animated: true, completion: nil)
        }.disposed(by: self.rx.disposeBag)
    }
    

    @IBAction func logoutAction(_ sender: Any) {
        let alertVC = UIAlertController.init(title: "", message: "确认退出登录？", defaultActionButtonTitle: "取消", tintColor: Color(hexString: "#2BB8C2"))
        alertVC.addAction(title: "退出登录", style: .destructive, isEnabled: true) { _ in
            NotificationCenter.default.post(name: Notification.Name("LSNetwork.RELOGIN"), object: nil)
        }
        alertVC.show()
    }
}


extension LSUserInfoViewController: ImagePickerControllerDelegate {

    func imagePickerDidCancel(_ picker: ImagePickerController) {
        /*
          你的业务代码，处理用户取消(存在默认实现，如果需要额外行为请自行实现本方法)
        */
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: ImagePickerController, didFinishPicking result: PickerResult) {
        guard let image = result.assets.map({ $0.image }).last else {
            return
        }
        Toast.showHUD()
        var headimg = ""
        LSUploadServer.fileUpload(image: image).asObservable().flatMap { uploadFileModel in
            guard let uploadFileModel = uploadFileModel else {
                return Observable<LSNetworkResultModel>.error(LSNetworkResultError.common("图片上传失败，请稍后重试"))
            }
            headimg = uploadFileModel.imgurl
            return LSUserServer.userUpdate(headimg: headimg).asObservable()
        }.subscribe { _ in
            self.iconImageView.image = image
            var userModel: LSUserModel = userModel()
            userModel.headimg = headimg
            LSLoginModel.shared.user = userModel
            LoginDataCache.setItem(LSLoginModel.shared, forKey: "LoginInfo")
            Toast.show("头像已更新")
        } onError: {  error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            picker.dismiss(animated: true, completion: nil)
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
}

