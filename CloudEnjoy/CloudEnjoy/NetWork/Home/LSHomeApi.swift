//
//  LSHomeApi.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/24.
//

import Foundation
import LSNetwork
import Moya
import LSBaseModules

extension LSHomeAPI.APIPath {
    static let findJsHomeData = "daysum/findJsHomeData"
}
enum LSHomeAPI: TargetType {
    struct APIPath {}
    
    case findJsHomeData
    
}

extension LSHomeAPI: LSTargetType{
    var path: String {
        switch self {
        case .findJsHomeData:
            return APIPath.findJsHomeData
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var originParams: [String : Any]? {
        switch self {
        case .findJsHomeData:
            return ["userid": userModel().userid]
        }

    }
    
    
    
}
