//
//  NotificationName.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//

import Foundation


extension Notification.Name{
    static let reLogin = Notification.Name("LSNetwork.RELOGIN")
    static let refreshToken = Notification.Name("LSNetwork.REFRESHTOKEN")

    static let logout = Notification.Name("LSAccount.LOGOUT")
    static let login = Notification.Name("LSAccount.LOGIN")
}
