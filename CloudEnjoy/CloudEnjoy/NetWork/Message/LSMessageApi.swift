//
//  LSMessageApi.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/24.
//

import Foundation
import LSNetwork
import Moya
import LSBaseModules

extension LSMessageAPI.APIPath {
    static let getList = "usermsg/getList"
    static let msgUpdate = "usermsg/update"
    static let getSeeCount = "usermsg/getMsgSeeCount"
}
enum LSMessageAPI: TargetType {
    struct APIPath {}
    
    case getList(ispage: String,
                  page: String,
                  see: String,
                 msgtype: String)
    
    case msgUpdate(msgids: String,
                   mtype: String)
    
    case getSeeCount
    
}

extension LSMessageAPI: LSTargetType{
    var path: String {
        switch self {
        case .getList:
            return APIPath.getList
        case .msgUpdate:
            return APIPath.msgUpdate
        case .getSeeCount:
            return APIPath.getSeeCount
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var originParams: [String : Any]? {
        switch self {
        case let .getList(ispage, page, see, msgtype):
            
            var params: [String : Any] = ["ispage": ispage,
                                          "userid": userModel().userid]
            if page.isEmpty == false {
                params["page"] = page
                params["pagesize"] = 10
            }
            if see.isEmpty == false {
                params["see"] = see
            }
            if msgtype.isEmpty == false {
                params["msgtype"] = msgtype
            }
            return params
        case let .msgUpdate(msgids, mtype):
            return ["msgids": msgids,
                    "mtype": mtype,
                    "userid": userModel().userid]
        case .getSeeCount:
            return ["userid": userModel().userid]
        }

    }
    
    
    
}

