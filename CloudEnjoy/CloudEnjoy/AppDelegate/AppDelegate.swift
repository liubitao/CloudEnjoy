//
//  AppDelegate.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initThirdPlatform(launchOptions)
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        debugPrint("did Fail To Register For Remote Notifications With Error: \(error)")
    }
}
