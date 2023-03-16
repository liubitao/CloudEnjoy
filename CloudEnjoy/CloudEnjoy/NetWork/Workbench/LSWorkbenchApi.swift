//
//  LSWorkbenchApi.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/11.
//

import Foundation
import LSNetwork
import Moya
import LSBaseModules

extension LSWorkbenchAPI.APIPath {
    static let findMeByCommission = "daysum/findMeByCommission"
    static let findMeCommission = "daysum/findMeCommission"
    
    static let findMeClockNum = "daysum/findMeClockNum"
    
    static let getSaleUserProjectMe = "sysuser/getSaleUserProjectMe"
    
    static let getVipList = "vipInfo/getList"
    
    static let insertAppointment = "about/insert"
    
    static let userGetList = "sysuser/getList"
}

enum LSWorkbenchAPI: TargetType {
    struct APIPath {}

    case findMeByCommission(startdate: String,
                             enddate: String)
    case findMeCommission(page: Int,
                          startdate: String,
                          enddate: String,
                          selecttype: Int)
    
    case findMeClockNum(startdate: String,
                        enddate: String)
    
    case getSaleUserProjectMe(page: Int,
                              startdate: String,
                              enddate: String,
                              status: LSOrderServerStatus)
    
    case getVipList(page: Int,
                        cond: String)
    
    case insertAppointment(name: String,
                           mobile: String,
                           custtype: LSCustomerType,
                           qty: String,
                           refid: String,
                           tostoretime: String,
                           reservemin: String,
                           remark: String,
                           roomlist: [LSRoomModel],
                           projectlist: [LSProjectModel])
    
    case userGetList
}


extension LSWorkbenchAPI: LSTargetType{
    var path: String {
        switch self {
        case .findMeByCommission:
            return APIPath.findMeByCommission
        case .findMeCommission:
            return APIPath.findMeCommission
        case .findMeClockNum:
            return APIPath.findMeClockNum
        case .getSaleUserProjectMe:
            return APIPath.getSaleUserProjectMe
        case .getVipList:
            return APIPath.getVipList
        case .insertAppointment:
            return APIPath.insertAppointment
        case .userGetList:
            return APIPath.userGetList
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var originParams: [String : Any]? {
        switch self {
        case let .findMeByCommission(startdate, enddate):
            return ["userid": userModel().userid,
                    "startdate": startdate,
                    "enddate": enddate]
        case let .findMeCommission(page, startdate, enddate, selecttype):
            return ["userid": userModel().userid,
                    "page": page,
                    "pagesize": 10,
                    "startdate": startdate,
                    "enddate": enddate,
                    "selecttype": selecttype]
        case let .findMeClockNum(startdate, enddate):
            return ["userid": userModel().userid,
                    "startdate": startdate,
                    "enddate": enddate]
        case let .getSaleUserProjectMe(page, startdate, enddate, status):
            return ["userid": userModel().userid,
                    "page": page,
                    "pagesize": 10,
                    "startdate": startdate,
                    "enddate": enddate,
                    "status": status.rawValue]
        case let .getVipList(page, cond):
            return ["page": page,
                    "pagesize": 10,
                    "cond": cond]
        case let .insertAppointment(name, mobile, custtype, qty, refid, tostoretime, reservemin, remark, roomlist, projectlist):
            return ["name": name,
                    "mobile": mobile,
                    "custtype": custtype.rawValue,
                    "qty": qty,
                    "refid": refid,
                    "tostoretime": tostoretime,
                    "reservemin": reservemin,
                    "remark": remark,
                    "roomlist": roomlist.toJSON(),
                    "projectlist": projectlist.toJSON()]
            
        case .userGetList:
            return ["is_page": 0,
                    "stopflag": 0,
                    "storeid": storeModel().id]
        }
    }
    
    
    
}
