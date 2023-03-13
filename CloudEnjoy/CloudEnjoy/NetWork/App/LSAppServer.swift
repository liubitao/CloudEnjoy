//
//  LSAppServer.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/8.
//

import Foundation
import LSNetwork
import RxSwift
import LSBaseModules

class LSAppServer {
    static let provider = LSProvider<LSAppAPI>()
    
    static func findAgreementList() -> Single<[LSAgreementModel]>{
        if let agreementModels: [LSAgreementModel] = AppDataCache.getItem(Array<LSAgreementModel>.self, forKey: "appAgreement") {
            return Single.just(agreementModels)
        }
        return provider.lsRequest(.findAgreementList).mapHandyModel(type: LSNetworkListModel<LSAgreementModel>.self)
        .map({ listModel in
            return listModel?.list ?? [LSAgreementModel]()
        }).flatMap({ list in
            if list.isEmpty{
                return Single.error(LSNetworkResultError.common("暂未查询到协议详情，请稍后再试"))
            }else {
                return Single.just(list)
            }
        }).do { list in
            AppDataCache.setItem(list, forKey: "appAgreement")
        }
    }
    
    static func getVersion() -> Single<LSVerisonModel?>{
        return provider.lsRequest(.getVersion).mapHandyModelArray(type: LSVerisonModel.self).map { $0?.last}
    }
}
