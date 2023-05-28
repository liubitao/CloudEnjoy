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
        NotificationCenter.default.addObserver(self, selector: #selector(setApp), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func setKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    @objc private func setApp() {
        let screenBool = AppDataCache.get(key: "screenSwitch") as? Bool ?? true
        UIApplication.shared.isIdleTimerDisabled = screenBool
//        UIApplication.shared.addObserver(self, forKeyPath: "isIdleTimerDisabled", options: .new, context: nil)
    }
    
}

extension AppDelegate {
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let screenBool = AppDataCache.get(key: "screenSwitch") as? Bool ?? true
        UIApplication.shared.isIdleTimerDisabled = screenBool
    }
}

