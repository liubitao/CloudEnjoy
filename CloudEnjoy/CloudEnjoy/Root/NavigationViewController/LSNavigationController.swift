//
//  LSNavigationController.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//   
//

import UIKit
import SwifterSwift

class LSNavigationController: UINavigationController {
    /// 定义防止重复push pop的标志
    private var isPushing = false
    private var isPoping = false
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .fullScreen
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.modalPresentationStyle = .fullScreen
        self.interactivePopGestureRecognizer?.delegate = self
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if isPushing { return }
        isPushing = true
        
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
            let btn = UIButton(type: .custom)
            btn.setImage(UIImage(named: "返回"), for: .normal)
            btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            btn.addTarget(viewController, action: NSSelectorFromString("itemBackTouchIn"), for: .touchUpInside)
            aView.addSubview(btn)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: aView)
        }
        
        super.pushViewController(viewController, animated: animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPushing = false
        }
    }
    
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if isPushing || isPoping {
            return nil
        }
        isPoping = true
        
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isPoping = false
            }
        }
        
        return super.popViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if isPushing || isPoping {
            return nil
        }
        
        isPoping = true
        
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isPoping = false
            }
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if isPushing || isPoping {
            return nil
        }
        
        isPoping = true
        
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isPoping = false
            }
        }
        
        if self.viewControllers.count > 1 {
            self.topViewController?.hidesBottomBarWhenPushed = false
        }
        return super.popToRootViewController(animated: animated)
        
    }
}


extension LSNavigationController {
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return viewControllers.first?.preferredStatusBarStyle ?? .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
          return self.topViewController
    }
    
    override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
}

extension LSNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1 {
            return false
        }
        return true
    }
}
