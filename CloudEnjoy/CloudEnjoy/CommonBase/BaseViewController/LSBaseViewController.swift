//
//  LSBaseViewController.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//   
//

import UIKit
import RxSwift
import LSBaseModules
import SwifterSwift

protocol BaseControllerInit {
    
    func setupNavigation()
    func setupViews()
    func setupData()
    func setupNotifications()
}

class LSBaseViewController: UIViewController, BaseControllerInit{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .fullScreen
    }
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color(hexString: "#F3F8FF")
        
        self.vhl_navBarBackgroundColor = Color(hexString: "#FFFFFF")!
        self.vhl_navBarShadowImageHide = true
        self.vhl_interactivePopEnable = true
        
        setupNavigation()
        setupViews()
        setupData()
        setupNotifications()
    }
    func setupNavigation() {
    }
    
    func setupViews() {}
    func setupData() {}
    func setupNotifications() {}
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    deinit {
//        type(of: self).cancelPreviousPerformRequests(withTarget: self)
//        let name =  type(of: self).description()
//        let className = name.components(separatedBy: ".")[1]
    }
    
    // MARK: - 标记 methods
    @objc func itemBackTouchIn() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            if viewControllerNameback.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }else {
                for viewController in navigationController!.viewControllers {
                    if NSStringFromClass(type(of: viewController)) == viewControllerNameback {
                        self.navigationController?.popToViewController(viewController, animated: true)
                        return
                    }
                }
                self.navigationController?.popViewController(animated: true)
            }
        } else if self.navigationController?.presentingViewController != nil {
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            assertionFailure("Never show up")
        }
    }
    
    func addBackBarButtonItem(selector: Selector? = nil, target: Any? = nil) {
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "返回"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.addTarget(self, action: NSSelectorFromString("itemBackTouchIn"), for: .touchUpInside)
        aView.addSubview(btn)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: aView)
    }
}


extension LSBaseViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
}





