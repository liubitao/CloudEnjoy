//
//  LSPhoneLoginView.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/4.
//

import UIKit
import JXSegmentedView
import RxSwift
import LSBaseModules

class LSPhoneLoginView: UIView {
    
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var loginClosure: LoginClosure?

    
    class func createFromXib() -> Self {
        let view = Bundle.main.loadNibNamed("LSPhoneLoginView", owner: nil)?.last
        return view as! Self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    
    func setupViews() {
        self.backgroundColor = UIColor.white
        [self.phoneView, self.passwordView].forEach { view in
            view.borderWidth = 1
            view.borderColor = UIColor(hexString: "#D2D2D2")
            view.cornerRadius = 3
        }
        
        if let loginAccountString = LoginAccountCache.get(key: "loginAccount") as? String,
           let loginModel = LSLoginAccountModel.deserialize(from: loginAccountString) {
            self.phoneTextField.text = loginModel.mobile
        }
        
        self.loginBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#E4E7ED")!, size: CGSize(width: UI.SCREEN_WIDTH - 19*2, height: 43)), for: .disabled)
        self.loginBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#00AAB7")!, size: CGSize(width: UI.SCREEN_WIDTH - 19*2, height: 43)), for: .normal)
        self.loginBtn.cornerRadius = 5

        let phoneValid = phoneTextField.rx.text.orEmpty.map{$0.count > 0}
        let passwordValid = passwordTextField.rx.text.orEmpty.map{$0.count > 0}

        let everythingOk = Observable.combineLatest(phoneValid, passwordValid){ $0 && $1}
        everythingOk.bind(to: self.loginBtn.rx.isEnabled).disposed(by: self.rx.disposeBag)
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let phone = phoneTextField.text,
              let password = passwordTextField.text else {return}
        self.loginClosure?(nil, nil, phone, password)
    }
    
}

extension LSPhoneLoginView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
