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
    static let getVipInfo = "vipInfo/getVipInfoList"
    
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
    static let aboutUpdate = "about/update"
    
    static let projectDetails = "sysuser/getSaleUserProjectMeDetail"
    
    
    static let getLeaveList = "leave/getList"
    static let insertLeave = "leave/insert"
    static let cancelLeave = "leave/updatestatus"
    static let getLeaveTypeList = "otherinfo/getLeavetypeList"
    
    static let getPlaceList = "place/getList"
    static let getPlacePunchin = "place/getPunchin"
    static let getPlacePunchinList = "place/getPunchinList"
    static let placePunchin = "place/punchin"
    
    static let getOrderInfo = "about/getInfo"
    
    
    static let getSaleUserProjectMeSum = "sysuser/getSaleUserProjectMeSum"
    static let getProjectRanking = "daysum/findProjectRanking"
    
    static let getShiftList = "shift/getList"
    static let getArtificerList = "artificer/getArtificerChangeList"
    static let getSysJobList = "sysjob/getList"
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
                              status: LSOrderServerStatus,
                              projectid: String)
    
    case getVipList(page: Int,
                        cond: String)
    case getVipInfo(spid: String,
                    sid: String,
                    vipid: String)
    
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
                            projecttypeid: String,
                            tid: String)
    
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
    
    case projectDetails(billid: String)
    
    case getLeaveList(page: Int)
    case insertLeave(leavetypeid: String,
                     leavetypename: String,
                     starttime: String,
                     endtime: String,
                     hours: String,
                     remark: String,
                     name: String,
                     branchname: String)
    case cancelLeave(billid: String,
                     cencelremark: String)
    case getLeaveTypeList
    
    case getPlaceList
    case getPlacePunchin(datetime: String)
    case getPlacePunchinList(datetime: String)
    case placePunchin(adr: String)
    
    case getOrderInfo(billid: String)
    
    case getSaleUserProjectMeSum(startdate: String,
                                 enddate: String,
                                 status: String)
    
    case getProjectRanking(startdate: String,
                           enddate: String)
    
    case getShiftList
    case getArtificerList(jobid: String,
                          shiftid: String)
    
    case getSysJobList
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
        case .getVipInfo:
            return APIPath.getVipInfo
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
        case .projectDetails:
            return APIPath.projectDetails
        case .getLeaveList:
            return APIPath.getLeaveList
        case .insertLeave:
            return APIPath.insertLeave
        case .cancelLeave:
            return APIPath.cancelLeave
        case .getLeaveTypeList:
            return APIPath.getLeaveTypeList
        case .getPlaceList:
            return APIPath.getPlaceList
        case .getPlacePunchin:
            return APIPath.getPlacePunchin
        case .getPlacePunchinList:
            return APIPath.getPlacePunchinList
        case .placePunchin:
            return APIPath.placePunchin
        case .getOrderInfo:
            return APIPath.getOrderInfo
        case .getSaleUserProjectMeSum:
            return APIPath.getSaleUserProjectMeSum
        case .getProjectRanking:
            return APIPath.getProjectRanking
        case .getShiftList:
            return APIPath.getShiftList
        case .getArtificerList:
            return APIPath.getArtificerList
        case .getSysJobList:
            return APIPath.getSysJobList
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
        case let .getSaleUserProjectMe(page, startdate, enddate, status, projectid):
            return ["userid": userModel().userid,
                    "page": page,
                    "pagesize": 10,
                    "startdate": startdate,
                    "enddate": enddate,
                    "status": status.rawValue,
                    "projectid": projectid]
        case let .getVipList(page, cond):
            return ["page": page,
                    "pagesize": 10,
                    "cond": cond,
                    "searchtype": 1]
        case let .getVipInfo(spid, sid, vipid):
            return ["spid": spid,
                    "sid": sid,
                    "vipid": vipid,
                    "searchtype": 2,
                    "storeid": storeModel().id,
                    "userid": userModel().userid]
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
        case let .getProjectinfoList(cond, projecttypeid, tid):
            var params = ["is_page": "0", "stopflag": "0"]
            if cond.isEmpty == false {
                params["cond"] = cond
            }
            if projecttypeid.isEmpty == false {
                params["projecttypeid"] = projecttypeid
            }
            if tid.isEmpty == false {
                params["tid"] = tid
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
        case let .projectDetails(billid):
            return ["billid": billid]
        case let .getLeaveList(page):
            return ["is_page": 1,
                    "page": page,
                    "pagesize": 10,
                    "userid": userModel().userid]
        case let .insertLeave(leavetypeid, leavetypename, starttime, endtime, hours, remark, name, branchname):
            return ["userid": userModel().userid,
                    "leavetypeid": leavetypeid,
                    "leavetypename": leavetypename,
                    "starttime": starttime,
                    "endtime": endtime,
                    "hours": hours,
                    "remark": remark,
                    "name": name,
                    "branchname": branchname]
        case let .cancelLeave(billid, cencelremark):
            return ["billid": billid,
                    "userid": userModel().userid,
                    "cencelremark": cencelremark,
                    "status": "0"]
        case .getLeaveTypeList:
            return ["is_page": "0"]
        case .getPlaceList:
            return ["is_page": "0"]
        case let .getPlacePunchin(datetime):
            return ["userid": userModel().userid,
                    "datetime": datetime]
        case let .getPlacePunchinList(datetime):
            return ["userid": userModel().userid,
                    "datetime": datetime]
        case let .placePunchin(adr):
            return ["userid": userModel().userid,
                    "adr": adr]
            
        case let .getOrderInfo(billid):
            return ["billid": billid]
        case let .getSaleUserProjectMeSum(startdate, enddate, status):
            return ["userid": userModel().userid,
                    "startdate":startdate,
                    "enddate": enddate,
                    "status": status]
        case let .getProjectRanking(startdate, enddate):
            return ["startdate": startdate,
                    "enddate": enddate]
        case .getShiftList:
            return ["is_page": 0]
        case let .getArtificerList(jobid, shiftid):
            return ["jobid": jobid,
                    "shiftid": shiftid]
        case .getSysJobList:
            return ["tflag": 1]
        }

    }
    
    
    
}
