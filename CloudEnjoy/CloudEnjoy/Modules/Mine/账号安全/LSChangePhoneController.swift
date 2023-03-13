//
//  LSChangePhoneController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/9.
//

import UIKit
import RxSwift
import LSBaseModules
import LSNetwork

enum ChangePhoneType {
    case old
    case new
}
class LSChangePhoneController: LSBaseViewController {
    var type: ChangePhoneType!
    private var timeLeft: Int = 60

    @IBOutlet weak var phoneTitleLab: UILabel!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var sendSmsButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    class func creaeFromStoryboard(_ type: ChangePhoneType) -> Self {
        let sb = UIStoryboard.init(name: "LSAccountSecureStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSChangePhoneController") as! Self
        vc.type = type
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改绑定手机"
    }
    
    override func setupViews() {
        self.phoneTitleLab.text = self.type == .old ? "原手机号" : "新手机号"
        self.confirmBtn.setTitle(self.type == .old ? "下一步" : "确认", for: .normal)
        self.confirmBtn.setTitle(self.type == .old ? "下一步" : "确认", for: .disabled)
        self.phoneTextField.placeholder = self.type == .old ? "请输入原始手机号" : "请输入新手机号"
        self.confirmBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#E4E7ED")!, size: CGSize(width: UI.SCREEN_WIDTH - 10*2, height: 43)), for: .disabled)
        self.confirmBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#00AAB7")!, size: CGSize(width: UI.SCREEN_WIDTH - 10*2, height: 43)), for: .normal)
        
        let phoneValid = phoneTextField.rx.text.orEmpty.map{$0.count > 0}
        let verificationCodeValid = verificationCodeTextField.rx.text.orEmpty.map{$0.count > 0}
        
        let everythingOk = Observable.combineLatest(phoneValid, verificationCodeValid){ $0 && $1 }
        everythingOk.bind(to: self.confirmBtn.rx.isEnabled).disposed(by: self.rx.disposeBag)
    }
    private func startTimer() {
        self.timeLeft = 60
        self.sendSmsButton.isEnabled = false
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(until: { _ in
                self.timeLeft <= 0
            })
            .subscribe(onNext: { _ in
                self.timeLeft -= 1
                self.sendSmsButton.setTitle("(\(self.timeLeft)s)", for: .disabled)
            }, onCompleted: {
                self.sendSmsButton.isEnabled = true
            }, onDisposed: {
            })
            .disposed(by: self.rx.disposeBag)
    }
    
    @IBAction func sendSmsAction(_ sender: Any) {
        guard let phone = phoneTextField.text,
              phone.count > 0 else{
            Toast.show("请输入原始手机号")
            return
        }
        Toast.showHUD()
        LSUserServer.getCode(phone: phone, smstype: "6").subscribe { _ in
            self.startTimer()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let phone = phoneTextField.text,
              let code = verificationCodeTextField.text else{return}
        Toast.showHUD()
        let confirmSingle: Single<LSNetworkResultModel>!
        if self.type == .old {
            confirmSingle = LSUserServer.jcMobileCode(mobile: phone, code: code)
        }else {
            confirmSingle = LSUserServer.updateMobile(userid: userModel().userid, mobile: userModel().mobile, code: code, newmobile: phone)
        }
        confirmSingle.subscribe { _ in
            if self.type == .old {
                self.navigationController?.pushViewController(LSChangePhoneController.creaeFromStoryboard(.new), animated: true)
            }else {
                var userModel: LSUserModel = userModel()
                userModel.mobile = phone
                LSLoginModel.shared.user = userModel
                LoginDataCache.setItem(LSLoginModel.shared, forKey: "LoginInfo")
                self.navigationController?.popToRootViewController(animated: true)
                Toast.show("已修改绑定手机成功")
            }
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    

}
