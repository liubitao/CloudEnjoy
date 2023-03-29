//
//  LSHomeServer.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/24.
//

import Foundation
import LSNetwork
import RxSwift
import LSBaseModules


class LSHomeServer {
    static let provider = LSProvider<LSHomeAPI>()

    static func findJsHomeData() -> Single<LSJSHomeModel?>{
        return provider.lsRequest(.findJsHomeData).mapHandyModel(type: LSJSHomeModel.self)
    }
    
    
    static func findProjectRanking() -> Single<LSNetworkListModel<LSRankModel>?>{
        return provider.lsRequest(.findProjectRanking).mapHandyModel(type: LSNetworkListModel<LSRankModel>.self)
    }
}
