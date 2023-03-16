//
//  LSAccountLoginView.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/4.
//

import UIKit
import JXSegmentedView
import RxSwift

class LSAccountLoginView:  UIView {
    
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var storeTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var loginClosure: LoginClosure?
    
    class func createFromXib() -> Self {
        let view = Bundle.main.loadNibNamed("LSAccountLoginView", owner: nil)?.last
        return view as! Self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = UIColor.white
        [self.storeView, self.accountView, self.passwordView].forEach { view in
            view.borderWidth = 1
            view.borderColor = UIColor(hexString: "#D2D2D2")
            view.cornerRadius = 3
        }
        
        self.storeTextField.text = "80000001"
        self.accountTextField.text = "1001"
        self.passwordTextField.text = "12"
        self.loginBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#E4E7ED")!, size: CGSize(width: UI.SCREEN_WIDTH - 19*2, height: 43)), for: .disabled)
        self.loginBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#00AAB7")!, size: CGSize(width: UI.SCREEN_WIDTH - 19*2, height: 43)), for: .normal)
        self.loginBtn.cornerRadius = 5
        let storeValid = storeTextField.rx.text.orEmpty.map{$0.count > 0}
        let accountValid = accountTextField.rx.text.orEmpty.map{$0.count > 0}
        let passwordValid = passwordTextField.rx.text.orEmpty.map{$0.count > 0}

        let everythingOk = Observable.combineLatest(storeValid, accountValid, passwordValid){ $0 && $1 && $2 }
        everythingOk.bind(to: self.loginBtn.rx.isEnabled).disposed(by: self.rx.disposeBag)
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let store = storeTextField.text,
              let account = accountTextField.text,
              let password = passwordTextField.text else {return}
        self.loginClosure?(store, account, nil, password)
    }
}

extension LSAccountLoginView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}


