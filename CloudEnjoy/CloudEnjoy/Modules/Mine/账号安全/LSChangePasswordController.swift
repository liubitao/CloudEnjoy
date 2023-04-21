//
//  LSChangePasswordController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/9.
//

import UIKit
import RxSwift
import LSBaseModules

class LSChangePasswordController: LSBaseViewController {

    @IBOutlet weak var originalTextField: UITextField!
    @IBOutlet weak var newTextField: UITextField!
    @IBOutlet weak var againTextField: UITextField!

    
    @IBOutlet weak var confirmBtn: UIButton!
    class func creaeFromStoryboard() -> Self {
        let sb = UIStoryboard.init(name: "LSAccountSecureStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSChangePasswordController")
        return vc as! Self
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改密码"
    }
    
    override func setupViews() {
        self.confirmBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#E4E7ED")!, size: CGSize(width: UI.SCREEN_WIDTH - 10*2, height: 43)), for: .disabled)
        self.confirmBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#00AAB7")!, size: CGSize(width: UI.SCREEN_WIDTH - 10*2, height: 43)), for: .normal)
        
        let originalValid = originalTextField.rx.text.orEmpty.map{$0.count > 0}
        let newValid = newTextField.rx.text.orEmpty.map{$0.count > 0}
        let againValid = againTextField.rx.text.orEmpty.map{$0.count > 0}

        let everythingOk = Observable.combineLatest(originalValid, newValid, againValid){ $0 && $1 && $2 }
        everythingOk.bind(to: self.confirmBtn.rx.isEnabled).disposed(by: self.rx.disposeBag)
    }
    
    @IBAction func comnfirmAction(_ sender: Any) {
        guard let original = originalTextField.text,
              let new = newTextField.text,
              let again = againTextField.text,
                new == again else{
            Toast.show("请保持新密码和确认密码一致")
            return
        }
        
        Toast.showHUD()
        LSUserServer.updatePwd(userid: userModel().userid, pwd: original, newpwd: new, newpwd2: again)
            .subscribe { resultModel in
                NotificationCenter.default.post(name: Notification.Name("LSNetwork.RELOGIN"), object: nil)
                Toast.show("密码修改成功")
            } onFailure: { error in
                Toast.show(error.localizedDescription)
            } onDisposed: {
                Toast.hiddenHUD()
            }.disposed(by: self.rx.disposeBag)

    }
}
