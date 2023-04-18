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
    
    static func insertAppointment(name: String, mobile: String, custtype: LSCustomerType, qty: String, refid: String, tostoretime: String, reservemin: String, remark: String, roomlist: String, projectlist: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.insertAppointment(name: name, mobile: mobile, custtype: custtype, qty: qty, refid: refid, tostoretime: tostoretime, reservemin: reservemin, remark: remark, roomlist: roomlist, projectlist: projectlist))
    }
    
    static func userGetList(projectid: String = "", tlid: String = "", sex: String = "") -> Single<LSNetworkListModel<LSSysUserModel>?>{
        return provider.lsRequest(.userGetList(projectid: projectid, tlid: tlid, sex: sex)).mapHandyModel(type: LSNetworkListModel<LSSysUserModel>.self)
    }
    
    static func getRoominfoList(cond: String,
                            roomtypeid: String) -> Single<LSNetworkListModel<LSOrderRoomModel>?>{
        return provider.lsRequest(.getRoominfoList(cond: cond, roomtypeid: roomtypeid)).mapHandyModel(type: LSNetworkListModel<LSOrderRoomModel>.self)
    }
    
    static func getRoomtypeList(cond: String = "") -> Single<LSNetworkListModel<LSRoomTypeModel>?>{
        return provider.lsRequest(.getRoomtypeList(cond: cond)).mapHandyModel(type: LSNetworkListModel<LSRoomTypeModel>.self)
    }
    
    static func getProjectinfoList(cond: String = "",
                                   projecttypeid: String = "") -> Single<LSNetworkListModel<LSOrderProjectModel>?>{
        return provider.lsRequest(.getProjectinfoList(cond: cond, projecttypeid: projecttypeid)).mapHandyModel(type: LSNetworkListModel<LSOrderProjectModel>.self)
    }
    
    static func getProjecttypeList(cond: String = "") -> Single<LSNetworkListModel<LSProjectTypeModel>?>{
        return provider.lsRequest(.getProjectypeList(cond: cond)).mapHandyModel(type: LSNetworkListModel<LSProjectTypeModel>.self)
    }
    
    static func getLevelList() -> Single<LSNetworkListModel<LSJSLevelModel>?>{
        return provider.lsRequest(.getLevelList).mapHandyModel(type: LSNetworkListModel<LSJSLevelModel>.self)
    }
    
    static func findAboutMe() -> Single<LSNetworkListModel<LSOrderModel>?>{
        return provider.lsRequest(.findAboutMe).mapHandyModel(type: LSNetworkListModel<LSOrderModel>.self)
    }
    
    static func findAboutCreateMe() -> Single<LSNetworkListModel<LSOrderModel>?>{
        return provider.lsRequest(.findAboutCreateMe).mapHandyModel(type: LSNetworkListModel<LSOrderModel>.self)
    }
    
    static func cancelYuyue(billid: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.cancelYuyue(billid: billid))
    }
    
    static func updateYuyue(billid: String, name: String, mobile: String, custtype: LSCustomerType, qty: String, refid: String, tostoretime: String, reservemin: String, remark: String, roomlist: String, projectlist: String, status: String) -> Single<LSNetworkResultModel>{
        return provider.lsRequest(.aboutUpdate(billid: billid, name: name, mobile: mobile, custtype: custtype, qty: qty, refid: refid, tostoretime: tostoretime, reservemin: reservemin, remark: remark, roomlist: roomlist, projectlist: projectlist, status: status))
    }
    
    static func projectDetails(billid: String) -> Single<LSOrderDetailsModel?>{
        return provider.lsRequest(.projectDetails(billid: billid)).mapHandyModel(type: LSOrderDetailsModel.self)
    }
    
    static func getLeaveList(page: Int) -> Single<LSNetworkListModel<LSLeaveModel>?> {
        return provider.lsRequest(.getLeaveList(page: page)).mapHandyModel(type: LSNetworkListModel<LSLeaveModel>.self)
    }
    
    static func insertLeave(leavetypeid: String,
                            leavetypename: String,
                            starttime: String,
                            endtime: String,
                            hours: String,
                            remark: String,
                            name: String,
                            branchname: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.insertLeave(leavetypeid: leavetypeid, leavetypename: leavetypename, starttime: starttime, endtime: endtime, hours: hours, remark: remark, name: name, branchname: branchname))
    }
    
    static func cancelLeave(billid: String, cencelremark: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.cancelLeave(billid: billid, cencelremark: cencelremark))
    }
    
    
    static func getLeaveTypeList() -> Single<LSNetworkListModel<LSLeaveTypeModel>?> {
        return provider.lsRequest(.getLeaveTypeList).mapHandyModel(type: LSNetworkListModel<LSLeaveTypeModel>.self)
    }
    
    static func getPlaceList() -> Single<LSNetworkListModel<LSPlaceModel>?> {
        return provider.lsRequest(.getPlaceList).mapHandyModel(type: LSNetworkListModel<LSPlaceModel>.self)
    }
    
    static func getPlacePunchin(datetime: String) -> Single<LSPlacePunchinModel?> {
        return provider.lsRequest(.getPlacePunchin(datetime: datetime)).mapHandyModel(type: LSPlacePunchinModel.self)
    }
    
    static func getPlacePunchinList(datetime: String) -> Single<[LSPlacePunchinItemModel]?> {
        return provider.lsRequest(.getPlacePunchinList(datetime: datetime)).mapHandyModelArray(type: LSPlacePunchinItemModel.self)
    }
    
    
    static func placePunchin(adr: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.placePunchin(adr: adr))
    }
    
    static func getOrderInfo(billid: String) -> Single<LSOrderModel?> {
        return provider.lsRequest(.getOrderInfo(billid: billid)).mapHandyModel(type: LSOrderModel.self)
    }
}
