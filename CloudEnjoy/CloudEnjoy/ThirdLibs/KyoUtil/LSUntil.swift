//
//  LSUntil.swift
//  CloudEnjoy
//
//  Created by liubitao on 2025/7/31.
//

import Foundation

class LSUntil {
    /// 获取根视图控制器
    /// - Returns: KyoTabBarViewController 或 nil
    static func getRootViewController() -> LSTabBarViewController? {
        // 安全获取应用程序的根视图控制器
        guard let viewController = UIApplication.shared.delegate?.window??.rootViewController else {
            return nil
        }
        
        // 检查视图控制器类型并返回相应的 KyoTabBarViewController
        if viewController is RootViewController {
            return (viewController as? RootViewController)?.tabBarViewController
        } else if viewController is LSTabBarViewController {
            return viewController as? LSTabBarViewController
        } else {
            return nil
        }
    }

    /// 获取当前导航视图控制器
    /// - Returns: UINavigationController 或 nil
    static func getCurrentNavigationViewController() -> UINavigationController? {
        // 获取根视图控制器
        guard let tabViewController = getRootViewController() else {
            return nil
        }
        
        // 获取当前选中的视图控制器并检查是否为导航控制器
        let viewController = tabViewController.selectedViewController
        return viewController as? UINavigationController
    }

}
