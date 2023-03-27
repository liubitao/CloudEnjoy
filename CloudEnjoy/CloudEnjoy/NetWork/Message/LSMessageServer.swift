//
//  LSMessageServer.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/24.
//

import Foundation
import LSNetwork
import RxSwift
import LSBaseModules


class LSMessageServer {
    static let provider = LSProvider<LSMessageAPI>()

    static func getMessageList(ispage: String,
                               see: String,
                               msgtype: String,
                               page: String = "") -> Single<LSNetworkListModel<LSMessageModel>?>{
        return provider.lsRequest(.getList(ispage: ispage, page: page, see: see, msgtype: msgtype)).mapHandyModel(type: LSNetworkListModel<LSMessageModel>.self)
    }
    
    static func msgUpdate(msgids: String,
                          mtype: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.msgUpdate(msgids: msgids, mtype: mtype))
    }
    
    
    
    static func getSeeCount() -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.getSeeCount)
    }
}
