//
//  LSAccountSecureController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/9.
//

import UIKit
import RxGesture

class LSAccountSecureController: LSBaseViewController {

    @IBOutlet weak var changePasswordView: UIView!
    
    @IBOutlet weak var changePhoneView: UIView!
    
    class func creaeFromStoryboard() -> Self {
        let sb = UIStoryboard.init(name: "LSAccountSecureStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSAccountSecureController")
        return vc as! Self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "账号安全"
    }
    
    override func setupViews() {
        self.changePasswordView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            self?.navigationController?.pushViewController(LSChangePasswordController.creaeFromStoryboard(), animated: true)
        }.disposed(by: self.rx.disposeBag)
        self.changePhoneView.rx.tapGesture().when(.recognized).subscribe { [weak self]_ in
            self?.navigationController?.pushViewController(LSChangePhoneController.creaeFromStoryboard(.old), animated: true)
        }.disposed(by: self.rx.disposeBag)
    }
    


}
