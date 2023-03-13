//
//  LSWorkbenchApi.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/11.
//

import Foundation
import LSNetwork
import Moya
import LSBaseModules

extension LSWorkbenchAPI.APIPath {
    static let findMeByCommission = "daysum/findMeByCommission"
    static let findMeCommission = "daysum/findMeCommission"
}

enum LSWorkbenchAPI: TargetType {
    struct APIPath {}

    case findMeByCommission(startdate: String,
                             enddate: String)
    case findMeCommission(page: Int,
                          startdate: String,
                          enddate: String,
                          selecttype: Int)
}


extension LSWorkbenchAPI: LSTargetType{
    var path: String {
        switch self {
        case .findMeByCommission:
            return APIPath.findMeByCommission
        case .findMeCommission:
            return APIPath.findMeCommission
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var originParams: [String : Any]? {
        switch self {
        case let .findMeByCommission(startdate, enddate):
            return ["userid": userModel().userid,
                    "startdate": startdate,
                    "enddate": enddate]
        case let .findMeCommission(page, startdate, enddate, selecttype):
            return ["userid": userModel().userid,
                    "page": page,
                    "pagesize": 10,
                    "startdate": startdate,
                    "enddate": enddate,
                    "selecttype": selecttype]
        }
    }
    
    
    
}
