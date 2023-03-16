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
    
    
    static func findMeClockNum(startdate: String, enddate: String) -> Single<LSFindMeClockNumModel?>{
        return provider.lsRequest(.findMeClockNum(startdate: startdate, enddate: enddate)).mapHandyModel(type: LSFindMeClockNumModel.self)
    }
    
    static func getSaleUserProjectMe(page: Int, startdate: String, enddate: String, status: LSOrderServerStatus) -> Single<LSNetworkListModel<LSOrderServerModel>?>{
        return provider.lsRequest(.getSaleUserProjectMe(page: page, startdate: startdate, enddate: enddate, status: status)).mapHandyModel(type: LSNetworkListModel<LSOrderServerModel>.self)
    }
    
    
    static func getVipList(page: Int, cond: String) -> Single<LSNetworkListModel<LSVipModel>?>{
        return provider.lsRequest(.getVipList(page: page, cond: cond)).mapHandyModel(type: LSNetworkListModel<LSVipModel>.self)
    }
    
    static func insertAppointment(name: String, mobile: String, custtype: LSCustomerType, qty: String, refid: String, tostoretime: String, reservemin: String, remark: String, roomlist: [LSRoomModel], projectlist: [LSProjectModel]) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.insertAppointment(name: name, mobile: mobile, custtype: custtype, qty: qty, refid: refid, tostoretime: tostoretime, reservemin: reservemin, remark: remark, roomlist: roomlist, projectlist: projectlist))
    }
    
    static func userGetList() -> Single<LSNetworkListModel<LSSysUserModel>?>{
        return provider.lsRequest(.userGetList).mapHandyModel(type: LSNetworkListModel<LSSysUserModel>.self)
    }
}
