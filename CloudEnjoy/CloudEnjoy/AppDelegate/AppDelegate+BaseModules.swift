//
//  AppDelegate+BaseModules.swift
//  Haylou_Fun
//
//  Created by liubitao on 2022/5/11.
//     
//

import Foundation
import IQKeyboardManagerSwift
import LSBaseModules

extension AppDelegate {
    func initBaseModules() {
        setKeyboard()   //键盘
        setApp()
    }
    
    private func setKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    private func setApp() {
        if appIsLogin() == true {
            let screenBool = AppDataCache.get(key: "screenSwitch") as? Bool ?? true
            UIApplication.shared.isIdleTimerDisabled = screenBool
        }
        UIApplication.shared.addObserver(self, forKeyPath: "idletimerdisabled", context: nil)
    }
    
}

extension AppDelegate {
    override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        let screenBool = AppDataCache.get(key: "screenSwitch") as? Bool ?? true
        UIApplication.shared.isIdleTimerDisabled = screenBool
    }
}

