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
    static let getUserStatus = "sysuser/getUserStatus"
    
    static let getSaleProject = "sale/getSaleUserProject"
    
    static let updateClockStatus = "sale/updateclockstatus"
    static let addClock = "sale/addClock"
    static let addProduct = "sale/addProduct"
    static let addService = "sale/addService"
    static let updateProject = "sale/updateProject"
    static let returnClock = "sale/returnClock"
    
    static let getGoodsTypeList = "bi/type/getTypeListandCode"
    static let getProductList = "bi/product/getProductList"
    
    static let getServiceList = "serviceinfo/getList"
    
    static let getYuyueInfo = "about/getInfo"
    
    static let bindHandcard = "salebill/setProHandcardid"
}
enum LSHomeAPI: TargetType {
    struct APIPath {}
    
    case findJsHomeData
    
    case findProjectRanking
    
    case getUserStatus
    
    case getSaleProject
    
    case updateClockStatus(billid: String, status: String)
    case addClock(billid: String,
                  projectid: String,
                  qty: String,
                  refid: String,
                  refname: String)
    case addProduct(billid: String,
                    roomid: String,
                    bedid: String,
                    refid: String,
                    refname: String,
                    refjobid: String,
                    productlist: String,
                    remark: String)
    case addService(billid: String,
                    roomid: String,
                    bedid: String,
                    remark: String,
                    servicelist: String)
    case updateProject(billid: String,
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
                       refjobid: String)
    case returnClock(billid: String,
                     remark: String)
    
    case getGoodsTypeList(spid: String,
                          sid: String)
    case getProductList(spid: String,
                        sid: String,
                        is_page: String,
                        page: String,
                        typeid: String,
                        itemstatus: String,
                        name: String,
                        quick: String)
    
    case getServiceList
    
    case getYuyueInfo(billid: String)
    
    case bindHandcard(billid: String,
                      roomid: String,
                      handcardid: String,
                      handcardno: String)
    
}

extension LSHomeAPI: LSTargetType{
    var path: String {
        switch self {
        case .findJsHomeData:
            return APIPath.findJsHomeData
        case .findProjectRanking:
            return APIPath.findProjectRanking
        case .getUserStatus:
            return APIPath.getUserStatus
        case .getSaleProject:
            return APIPath.getSaleProject
        case .updateClockStatus:
            return APIPath.updateClockStatus
        case .addClock:
            return APIPath.addClock
        case .addProduct:
            return APIPath.addProduct
        case .addService:
            return APIPath.addService
        case .updateProject:
            return APIPath.updateProject
        case .returnClock:
            return APIPath.returnClock
        case .getGoodsTypeList:
            return APIPath.getGoodsTypeList
        case .getProductList:
            return APIPath.getProductList
        case .getServiceList:
            return APIPath.getServiceList
        case .getYuyueInfo:
            return APIPath.getYuyueInfo
        case .bindHandcard:
            return APIPath.bindHandcard
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
            return ["startdate": Date().stringTime24(withFormat:"yyyy-MM-dd"),
                    "enddate": Date().stringTime24(withFormat:"yyyy-MM-dd")]
        case .getUserStatus:
            return ["userid": userModel().userid]
        case .getSaleProject:
            return ["userid": userModel().userid]
        case let .updateClockStatus(billid, status):
            return ["billid": billid,
                    "status": status]
        case let .addClock(billid, projectid, qty, refid, refname):
            return ["billid": billid,
                    "projectid": projectid,
                    "qty": qty,
                    "refid": refid,
                    "refname": refname]
        case let .addProduct(billid, roomid, bedid, refid, refname, refjobid, productlist, remark):
            return ["billid": billid,
                    "roomid": roomid,
                    "bedid": bedid,
                    "refid": refid,
                    "refname": refname,
                    "refjobid": refjobid,
                    "productlist": productlist,
                    "remark": remark]
        case let .addService(billid, roomid, bedid, remark, servicelist):
            return ["billid": billid,
                    "roomid": roomid,
                    "bedid": bedid,
                    "remark": remark,
                    "servicelist": servicelist]
        case let .updateProject(billid, roomid, roomname, handcardid, handcardno, bedid, bedname, projectid, projectname, min, refid, refname, refjobid):
            return ["billid": billid,
                    "roomid": roomid,
                    "roomname": roomname,
                    "handcardid": handcardid,
                    "handcardno": handcardno,
                    "bedid": bedid,
                    "bedname": bedname,
                    "projectid": projectid,
                    "projectname": projectname,
                    "min": min,
                    "refid": refid,
                    "refname": refname,
                    "refjobid": refjobid]
        case let .returnClock(billid, remark):
            return ["billid": billid,
                    "remark": remark]
        case let .getGoodsTypeList(spid, sid):
            return ["spid": spid,
                    "sid": sid]
        case let .getProductList(spid, sid, is_page, page, typeid, itemstatus, name, quick):
            return ["spid": spid,
                    "sid": sid,
                    "is_page": is_page,
                    "page": page,
                    "pagesize": 20,
                    "typeid": typeid,
                    "itemstatus": itemstatus,
                    "name": name,
                    "quick": quick]
        case .getServiceList:
            return ["is_page": "0",
                    "stopflag": "0"]
        case let .getYuyueInfo(billid):
            return ["billid": billid]
        case let .bindHandcard(billid, roomid, handcardid, handcardno):
            return ["billid": billid,
                    "roomid": roomid,
                    "handcardid": handcardid,
                    "handcardno": handcardno]
        }

    }
    
    
    
}
