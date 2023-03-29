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
    static let findProjectRanking = "daysum/findProjectRanking"
}
enum LSHomeAPI: TargetType {
    struct APIPath {}
    
    case findJsHomeData
    
    case findProjectRanking
    
    
}

extension LSHomeAPI: LSTargetType{
    var path: String {
        switch self {
        case .findJsHomeData:
            return APIPath.findJsHomeData
        case .findProjectRanking:
            return APIPath.findProjectRanking
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var originParams: [String : Any]? {
        switch self {
        case .findJsHomeData:
            return ["userid": userModel().userid]
        case .findProjectRanking:
            return ["startdate": Date().string(withFormat: "yyyy-MM-dd"),
                    "enddate": Date().string(withFormat: "yyyy-MM-dd")]
        }

    }
    
    
    
}
