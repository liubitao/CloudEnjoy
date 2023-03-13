//
//  LSWorkbenchServer.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/11.
//

import Foundation
import LSNetwork
import RxSwift
import LSBaseModules

class LSWorkbenchServer {
    static let provider = LSProvider<LSWorkbenchAPI>()
    
    static func findMeByCommission(startdate: String, enddate: String) -> Single<LSRoyaltiesTotalModel?>{
        return provider.lsRequest(.findMeByCommission(startdate: startdate, enddate: enddate)).mapHandyModel(type: LSRoyaltiesTotalModel.self)
    }
    
    static func findMeCommission(page: Int, startdate: String, enddate: String, selecttype: Int) -> Single<LSNetworkListModel<LSRoyaltiesDetailsModel>?>{
        return provider.lsRequest(.findMeCommission(page: page, startdate: startdate, enddate: enddate, selecttype: selecttype)).mapHandyModel(type: LSNetworkListModel<LSRoyaltiesDetailsModel>.self)
    }
  
}
