//
//  LSAboutViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import RxGesture


class LSAboutViewController: LSBaseViewController {

    @IBOutlet weak var agreementView: UIView!
    
    @IBOutlet weak var verisonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
    }
    
    override func setupViews() {
        verisonLabel.text = "V\(UIApplication.shared.version.unwrapped(or: ""))"
        
        self.agreementView.rx.tapGesture().when(.recognized).asObservable().flatMap { _ in
            Toast.showHUD()
            return LSAppServer.findAgreementList().asObservable()
        }.subscribe(onNext: {[weak self] list in
            guard let self = self,
                  let agreementModel = list.first(where: {$0.id == 5}) else {
                Toast.show("暂未查询到协议详情，请稍后再试")
                return
            }
            Toast.hide()
            self.navigationController?.pushViewController(LSTextViewController(titleName: agreementModel.agreementname, content: agreementModel.content), animated: true)
        }, onError: {  error in
            Toast.show(error.localizedDescription)
        }, onDisposed: {
            Toast.hide()
        }).disposed(by: self.rx.disposeBag)
    }
}
