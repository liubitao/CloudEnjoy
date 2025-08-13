//
//  LSJPushServer.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/4.
//

import Foundation
import LSNetwork
import RxSwift
import LSBaseModules
import SmartCodable

class LSJPushServer {
    static let provider = LSProvider<LSJPushAPI>()
    
    static func bind(deviceToken: String, userid: String, spid: String, sid: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.bind(deviceToken: deviceToken, userid: userid, spid: spid, sid: sid))
    }
    
    static func unBind(deviceToken: String, userid: String, spid: String, sid: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.unBind(deviceToken: deviceToken, userid: userid, spid: spid, sid: sid))
    }
}
