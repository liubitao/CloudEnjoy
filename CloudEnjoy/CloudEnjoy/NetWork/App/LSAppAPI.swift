//
//  LSAppAPI.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/8.
//

import Foundation
import LSNetwork
import Moya

extension LSAppAPI.APIPath {
    static let findAgreementList = "version/findAgreementList"
    static let getVersion = "version/getversion"
}

enum LSAppAPI {
    struct APIPath {}
    
    case findAgreementList
    case getVersion
}


extension LSAppAPI: LSTargetType{
    var path: String {
        switch self {
        case .findAgreementList:
            return APIPath.findAgreementList
        case .getVersion:
            return APIPath.getVersion
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var originParams: [String : Any]? {
        switch self {
        case .findAgreementList:
            return ["clienttype": "3"]
        case .getVersion:
            return ["clienttype": "4",
                    "vocde": "100000",
                    "machserial": "",
                    "clientName": "IOSJS"]
        }
    }
}
