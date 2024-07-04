//
//  RootViewController.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//

import UIKit
import IQKeyboardManagerSwift
import LSNetwork
import LSBaseModules
import SnapKit
import SwifterSwift

class RootViewController: LSBaseViewController {
    
    var tabBarViewController: LSTabBarViewController?
    var loginVC: LSLoginViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLaunch()
    }

    override func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(otherLogin), name: LSMessageType.otherLogin.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .reLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .logout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupTabBarViewController), name: .login, object: nil)
    }
    
    func setupLaunch() {
        var launchViewController: LSLaunchViewController? = nil
        launchViewController = LSLaunchViewController(hide:{[weak self] in
            launchViewController?.removeFromParent()
            launchViewController?.view.removeFromSuperview()
            self?.showHomeViewController()
        })
        addChild(launchViewController!)
        view.addSubview(launchViewController!.view)
        launchViewController?.view.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    func showHomeViewController() {
        /// 根据数据库中的token判断
        guard appIsLogin() else {
            self.setupLoginViewController()
            return
        }
        
//        self.getUserInfo()
        LSRMQClient.install(rabbitaddress: LSLoginModel.shared.rabbitaddress, rabbitport: LSLoginModel.shared.rabbitport)
        self.setupTabBarViewController()
    }
    
    /// 主页
    @objc func setupTabBarViewController() {
        clearAllSub()
        tabBarViewController = LSTabBarViewController()
        addChild(tabBarViewController!)
        view.addSubview(tabBarViewController!.view)
        tabBarViewController!.view.sendSubviewToBack(view)
    }
    
    /// 登录界面
    @objc func setupLoginViewController() {
        clearAllSub()
        loginVC = LSLoginViewController()
        addChild(loginVC!)
        view.addSubview(loginVC!.view)
        loginVC?.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loginVC!.view.sendSubviewToBack(view)
    }
    
    /// 清空上次的记录
    func clearAllSub() {
        tabBarViewController?.view.removeFromSuperview()
        tabBarViewController?.removeFromParent()
        tabBarViewController = nil
        loginVC?.view.removeFromSuperview()
        loginVC?.removeFromParent()
        loginVC = nil
    }
    
    /// 请求用户信息并加入数据库中
    func getUserInfo() {
    }
    
    //退出登录，删除所有信息
    @objc func logout() {
        LSRMQClient.unInstall()
        LoginDataCache.removeAll()
        self.setupLoginViewController()
    }
    
    @objc func otherLogin() {
        let alertVC = UIAlertController.init(title: "", message: "该账号已被其他账号登录!", defaultActionButtonTitle: "取消", tintColor: Color(hexString: "#2BB8C2"))
        alertVC.addAction(title: "确定", style: .destructive, isEnabled: true) { _ in
        }
        alertVC.show()
        self.logout()
    }
}


extension RootViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    override var shouldAutorotate: Bool {
        return  false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
}

