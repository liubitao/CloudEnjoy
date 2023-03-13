//
//  LSLoginViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/2.
//

import UIKit
import SnapKit
import AttributedString
import SwifterSwift

class LSLoginViewController: LSBaseViewController {

    var agreePrivacyButton: UIButton!
    
    @IBOutlet weak var loginContentView: UIView!
    
    var loginView: LSLoginContentView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupViews() {
        let agreePrivacyView: UIView = {
            let agreePrivacyView = UIView()
            agreePrivacyView.backgroundColor = UIColor.clear
            self.view.addSubview(agreePrivacyView)
            agreePrivacyView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-12 - UI.BOTTOM_HEIGHT)
                make.height.equalTo(21)
            }
            return agreePrivacyView
        }()
        
        self.agreePrivacyButton = {
            let agreePrivacyButton = UIButton(type: .custom)
            agreePrivacyButton.setImage(UIImage(named: "协议-未选中"), for: .normal)
            agreePrivacyButton.setImage(UIImage(named: "协议-选中"), for: .selected)
            agreePrivacyButton.rx.tap.subscribe {[weak agreePrivacyButton] _ in
                agreePrivacyButton?.isSelected = !agreePrivacyButton!.isSelected
            }.disposed(by: self.rx.disposeBag)
            agreePrivacyView.addSubview(agreePrivacyButton)
            agreePrivacyButton.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            return agreePrivacyButton
        }()
        
        let _ = {
            let agreementLabel = UILabel()
            let agreement = "《用户服务协议》"
            let privit = "《隐私政策》"
            let holeText = String(format: "我同意 %@ 和 %@", agreement, privit)
            let agreementRange = holeText.nsString.range(of: agreement)
            let privitRange = holeText.nsString.range(of: privit)
            var agreementString = ASAttributedString.init(string: holeText, with: [.font(Font.pingFangRegular(14)), .foreground(Color(hexString: "#999999")!)])
            agreementString.add(attributes: [.foreground(Color(hexString: "#00AAB7")!), .underline(.single), .action{[weak self] in self?.pushUserPrivacy()}], range: agreementRange)
            agreementString.add(attributes: [.foreground(Color(hexString: "#00AAB7")!), .underline(.single), .action{[weak self] in self?.pushPrivacyPolicy()}], range: privitRange)
            agreementLabel.attributed.text = agreementString
            agreePrivacyView.addSubview(agreementLabel)
            agreementLabel.snp.makeConstraints { make in
                make.left.equalTo(agreePrivacyButton.snp.right).offset(5)
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            return agreementLabel
        }()
        
        let _ = {
            let loginView = LSLoginContentView(frame: CGRect.zero) {[weak self] store, account, phone, password in
                guard let self = self,
                      self.agreePrivacyButton.isSelected else {
                        Toast.show("请同意《用户服务协议》和《隐私政策》")
                        return
                }
                Toast.showHUD()
                LSUserServer.login(account: store, mobile: phone, code: account, pwd: password)
                    .subscribe { _ in
                        NotificationCenter.default.post(name: .login, object: nil)
                    } onFailure: { error in
                        Toast.show(error.localizedDescription)
                    } onDisposed: {
                        Toast.hide()
                    }.disposed(by: self.rx.disposeBag)
            }
            self.loginContentView.addSubview(loginView)
            loginView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return loginView
        }()
    }
    
    func pushUserPrivacy() {
        Toast.showHUD()
        LSAppServer.findAgreementList().subscribe { list in
            guard let agreementModel = list.first(where: {$0.id == 5}) else {
                Toast.show("暂未查询到协议详情，请稍后再试")
                return
            }
            let textViewController = LSTextViewController(titleName: agreementModel.agreementname, content: agreementModel.content)
            self.present(LSNavigationController(rootViewController: textViewController), animated: false)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hide()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func pushPrivacyPolicy() {
        Toast.showHUD()
        LSAppServer.findAgreementList().subscribe { list in
            guard let agreementModel = list.first(where: {$0.id == 6}) else {
                Toast.show("暂未查询到协议详情，请稍后再试")
                return
            }
            let textViewController = LSTextViewController(titleName: agreementModel.agreementname, content: agreementModel.content)
            self.present(LSNavigationController(rootViewController: textViewController), animated: false)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hide()
        }.disposed(by: self.rx.disposeBag)
    }
    
    
}
