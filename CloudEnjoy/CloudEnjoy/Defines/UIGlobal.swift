//
//  UIGloble.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//   
//

import UIKit


public struct UI {
    public static let SCREEN_BOUNDS = UIScreen.main.bounds
    public static let SCREEN_WIDTH = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    public static let SCREEN_HEIGHT = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

    public static let SCREEN_MAX_LENGTH  = max(SCREEN_WIDTH, SCREEN_HEIGHT)
    
    public static let STATUS_NAV_BAR_HEIGHT:CGFloat = statusBarHeight + navigationBarHeight
    public static let TABBAR_HEIGHT:CGFloat = statusBarHeight > 20 ? 83.0 : 49.0
    public static let BOTTOM_HEIGHT:CGFloat = statusBarHeight > 20 ? 34.0 : 0.0
    public static let STATUSBAR_HEIGHT:CGFloat = statusBarHeight
    
    //状态栏高度
    private static var statusBarHeight:CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            return statusBarManager.statusBarFrame.height
        }else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    //导航栏高度
    private static let navigationBarHeight:CGFloat = 44
}
