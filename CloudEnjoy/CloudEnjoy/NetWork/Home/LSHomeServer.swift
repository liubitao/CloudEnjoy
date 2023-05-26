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
    
    static func getUserStatus() -> Single<LSUserStatusModel?>{
        return provider.lsRequest(.getUserStatus).mapHandyModel(type: LSUserStatusModel.self)
    }
    
    
    static func getSaleProject() -> Single<[LSHomeProjectModel]?>{
        return provider.lsRequest(.getSaleProject).mapHandyModelArray(type: LSHomeProjectModel.self)
    }
    
    static func updateClockStatus(billid: String, status: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.updateClockStatus(billid: billid, status: status))
    }
                                  
    static func addClock(billid: String,
                         projectid: String,
                         qty: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.addClock(billid: billid, projectid: projectid, qty: qty))
    }
    
    static func addProduct(billid: String,
                           roomid: String,
                           bedid: String,
                           refid: String,
                           refname: String,
                           refjobid: String,
                           productlist: String,
                           remark: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.addProduct(billid: billid, roomid: roomid, bedid: bedid, refid: refid, refname: refname, refjobid: refjobid, productlist: productlist,
                                              remark: remark))
    }
    
    static func addService(billid: String,
                           roomid: String,
                           bedid: String,
                           remark: String,
                           servicelist: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.addService(billid: billid, roomid: roomid, bedid: bedid, remark: remark, servicelist: servicelist))
    }
    
    static func updateProject(billid: String,
                              roomid: String,
                              roomname: String,
                              handcardid: String,
                              handcardno: String,
                              bedid: String,
                              bedname: String,
                              projectid: String,
                              projectname: String,
                              min: String,
                              refid: String,
                              refname: String,
                              refjobid: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.updateProject(billid: billid, roomid: roomid, roomname: roomname, handcardid: handcardid, handcardno: handcardno, bedid: bedid, bedname: bedname, projectid: projectid, projectname: projectname, min: min, refid: refid, refname: refname, refjobid: refjobid))
    }
    
    
    static func returnClock(billid: String,
                            remark: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.returnClock(billid: billid, remark: remark))
    }
    
    
    static func getGoodsTypeList(spid: String,
                                 sid: String) -> Single<LSGoodsTypeModel?>{
        return provider.lsRequest(.getGoodsTypeList(spid: spid, sid: sid)).mapHandyModel(type: LSGoodsTypeModel.self)
    }
    
    static func getProductList(spid: String,
                               sid: String,
                               is_page: String,
                               page: String,
                               typeid: String,
                               itemstatus: String,
                               name: String,
                               quick: String) -> Single<LSNetworkListModel<LSGoodsModel>?>{
        return provider.lsRequest(.getProductList(spid: spid, sid: sid, is_page: is_page, page: page, typeid: typeid, itemstatus: itemstatus, name: name, quick: quick)).mapHandyModel(type: LSNetworkListModel<LSGoodsModel>.self)
    }
    
    static func getServiceList() -> Single<LSNetworkListModel<LSServiceModel>?>{
        return provider.lsRequest(.getServiceList).mapHandyModel(type: LSNetworkListModel<LSServiceModel>.self)
    }
}

