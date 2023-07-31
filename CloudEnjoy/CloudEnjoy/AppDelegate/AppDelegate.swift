//
//  AppDelegate.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initThirdPlatform()
        initBaseModules()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let rootViewController = RootViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
   
    func applicationWillEnterForeground(_ application: UIApplication) {
        FJDeepSleepPreventerPlus.sharedInstance().stop()

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        FJDeepSleepPreventerPlus.sharedInstance().start()
    }
}
