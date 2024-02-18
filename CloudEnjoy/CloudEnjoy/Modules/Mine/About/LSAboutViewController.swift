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
        
        {
            let icpLabel = UILabel()
            icpLabel.text = "ICP备案号: 粤ICP备14066122号-28A >"
            icpLabel.font = Font.pingFangRegular(14)
            icpLabel.textColor = UIColor.black
            self.view.addSubview(icpLabel)
            icpLabel.rx.tapGesture()
                .when(.recognized)
                .subscribe { _ in
                    let url = URL(string: "https://beian.miit.gov.cn/")!
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }.disposed(by: self.rx.disposeBag)
            icpLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-30 - UI.BOTTOM_HEIGHT)
                make.centerX.equalToSuperview()
            }
        }()
        
        
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
