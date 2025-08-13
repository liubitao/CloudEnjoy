//
//  LSJPushApi.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/4.
//

import Foundation
import LSNetwork
import Moya
import LSBaseModules

extension LSJPushAPI.APIPath {
    static let bind = "machine/bind"
    static let unBind = "machine/unbind"
}

enum LSJPushAPI {
    struct APIPath {}
    
    case bind(deviceToken: String, userid: String, spid: String, sid: String)
    case unBind(deviceToken: String, userid: String, spid: String, sid: String)
}


extension LSJPushAPI: LSTargetType{
    var path: String {
        switch self {
        case .bind:
            return APIPath.bind
        case .unBind:
            return APIPath.unBind
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var originParams: [String : Any]? {
        switch self {
        case let .bind(deviceToken, userid, spid, sid):
            return ["deviceToken": deviceToken,
                    "userid": userid,
                    "spid": spid,
                    "sid": sid]
        case let .unBind(deviceToken, userid, spid, sid):
            return ["deviceToken": deviceToken,
                    "userid": userid,
                    "spid": spid,
                    "sid": sid]
        }
    }
}
