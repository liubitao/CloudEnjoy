//
//  AppDelegate+ThirdPlatform.swift
//  Haylou_Fun
//
//  Created by liubitao on 2022/5/11.
//     
//

import Foundation
import LSBaseModules

extension AppDelegate{
    func initThirdPlatform(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // 友盟统计
        UMConfigure.initWithAppkey(ThirdsKey.UMKey.AppId, channel: nil)
        
        // 极光推送
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
#if DEBUG
        JPUSHService.setDebugMode() // 开启调试日志
#endif
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions,
                           appKey: ThirdsKey.JPushKey.AppKey,
                           channel: nil,
                           apsForProduction: false)
        JPUSHService.registrationIDCompletionHandler { resCode, registrationID in
            debugPrint("resCode : \(resCode),registrationID: \(String(describing: registrationID))")
        }
        clearIconBadgeNumber()
    }
    
    // 清除角标
    func clearIconBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
    }
    
//    billid:订单id,
//    type:appointment预约订单 service服务订单
    func jumpToPage(_ userInfo: [AnyHashable: Any]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            switch userInfo["type"] as? String {
            case "appointment":
                guard let billid = userInfo["billid"] as? String else {return}
                LSWorkbenchServer.findAboutMe()
                    .subscribe { listModel in
                        guard let orderModel = listModel?.list.first(where: {$0.billid == billid}) else {return}
                        LSUntil.getCurrentNavigationViewController()?.pushViewController(LSOrderDetailsViewController.init(orderModel: orderModel), animated: true)
                    }.disposed(by: self.disposeBag)
            case "service":
                LSUntil.getRootViewController()?.selectedIndex = 0
            default: break
            }
        }
    }
}

extension AppDelegate: JPUSHRegisterDelegate {
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]?) {
        debugPrint("jpushNotificationAuthorization : \(status),withInfo: \(String(describing: info))")
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
        if let trigger = notification.request.trigger,
           trigger.isKind(of: UNPushNotificationTrigger.self) {
            
        }else{
            
        }
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (Int) -> Void) {
        clearIconBadgeNumber()
        let userInfo = notification.request.content.userInfo
        if let trigger = notification.request.trigger,
           trigger.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue | UNNotificationPresentationOptions.sound.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        clearIconBadgeNumber()
        let userInfo = response.notification.request.content.userInfo
        if let trigger = response.notification.request.trigger,
           trigger.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(userInfo)
            jumpToPage(userInfo)
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
}
