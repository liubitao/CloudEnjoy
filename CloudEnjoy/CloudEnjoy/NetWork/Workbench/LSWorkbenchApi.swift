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

    static let getRoomtypeList = "otherinfo/getRoomtypeList"
    static let getRoominfoList = "roominfo/getList"
    
    static let getProjectypeList = "otherinfo/getProjecttypeList"
    static let getProjectinfoList = "projectinfo/getList"
    
    static let getLevelList = "otherinfo/getTechnicianlevelList"
    
    static let findAboutMe = "about/findAboutMe"
    static let findAboutCreateMe = "about/findAboutCreateMe"
    
    static let cancelYuyue = "about/updateStatus"
    static let aboutUpdate = "about/updateStatus"
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
                           roomlist: String,
                           projectlist: String)
    
    case userGetList(projectid: String,
                     tlid: String,
                     sex: String)
    
    case getRoominfoList(cond: String,
                         roomtypeid: String)
    case getRoomtypeList(cond: String)
    
    case getProjectypeList(cond: String)
    case getProjectinfoList(cond: String,
                            projecttypeid: String)
    
    case getLevelList
    
    case findAboutMe
    case findAboutCreateMe
    
    case cancelYuyue(billid: String)
    case aboutUpdate(billid: String,
                     name: String,
                    mobile: String,
                    custtype: LSCustomerType,
                    qty: String,
                    refid: String,
                    tostoretime: String,
                    reservemin: String,
                    remark: String,
                    roomlist: String,
                    projectlist: String,
                    status: String)
    
    
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
        case .getRoominfoList:
            return APIPath.getRoominfoList
        case .getRoomtypeList:
            return APIPath.getRoomtypeList
        case .getProjectypeList:
            return APIPath.getProjectypeList
        case .getProjectinfoList:
            return APIPath.getProjectinfoList
        case .getLevelList:
            return APIPath.getLevelList
        case .findAboutMe:
            return APIPath.findAboutMe
        case .findAboutCreateMe:
            return APIPath.findAboutCreateMe
        case .cancelYuyue:
            return APIPath.cancelYuyue
        case .aboutUpdate:
            return APIPath.aboutUpdate
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
                    "roomlist": roomlist,
                    "projectlist": projectlist]
            
        case let .userGetList(projectid, tlid, sex):
            var params = ["is_page": "0",
                          "stopflag": "0",
                          "storeid": storeModel().id]
            if projectid.isEmpty == false { params["projectid"] = projectid }
            if tlid.isEmpty == false { params["tlid"] = tlid }
            if sex.isEmpty == false { params["sex"] = sex }
            return params
        case let .getRoominfoList(cond, roomtypeid):
            var params = ["is_page": "0", "stopflag": "0"]
            if cond.isEmpty == false {
                params["cond"] = cond
            }
            if roomtypeid.isEmpty == false {
                params["roomtypeid"] = roomtypeid
            }
            return params
        case let .getRoomtypeList(cond):
            var params = ["is_page": "0"]
            if cond.isEmpty == false {
                params["cond"] = cond
            }
            return params
        case let .getProjectypeList(cond):
            var params = ["is_page": "0"]
            if cond.isEmpty == false {
                params["cond"] = cond
            }
            return params
        case let .getProjectinfoList(cond, projecttypeid):
            var params = ["is_page": "0", "stopflag": "0"]
            if cond.isEmpty == false {
                params["cond"] = cond
            }
            if projecttypeid.isEmpty == false {
                params["projecttypeid"] = projecttypeid
            }
            return params
        case .getLevelList:
            return ["is_page": "0"]
        case .findAboutMe:
            return ["userid": userModel().userid]
        case .findAboutCreateMe:
            return ["userid": userModel().userid]
        case let .cancelYuyue(billid):
            return ["billid": billid,
                    "status": "2"]
        case let .aboutUpdate(billid, name, mobile, custtype, qty, refid, tostoretime, reservemin, remark, roomlist, projectlist, status):
            return ["billid": billid,
                    "name": name,
                     "mobile": mobile,
                     "custtype": custtype.rawValue,
                     "qty": qty,
                     "refid": refid,
                     "tostoretime": tostoretime,
                     "reservemin": reservemin,
                     "remark": remark,
                     "roomlist": roomlist,
                     "projectlist": projectlist,
                        "status": status]
        }

    }
    
    
    
}
