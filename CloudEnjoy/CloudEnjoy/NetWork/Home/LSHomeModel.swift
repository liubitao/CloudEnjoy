//
//  LSHomeModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/24.
//

import Foundation
import HandyJSON
import SwifterSwift

struct LSJSHomeModel: HandyJSON {
    var basesaleductamt = ""
    var rechargesaleductamt = ""
    var txsaleductamt = ""
    var ph = "" //今日排行
    var commissionsum = ""  //今日提成
    var sumqty = "" //我的钟数
    var addcardsaleductamt = ""
    var userid = ""
    var overtimesaleductamt = ""
}


struct LSRankModel: HandyJSON {
    var headimg = ""
    var tlname = ""
    var sumqty = ""
    var usercode = ""
    var username = ""
}


enum LSUserStatus: Int, HandyJSONEnum {
    case rest = 0 //休息
    case leave = 1 //请假
    case noSign = 2 //未签到
    case circleCard = 3 //圈牌中
    case orderReceiving = 4 //接单中
    case waitClock = 5 //待上钟
    case servicing  = 6 //服务中
    case subscribe = 7 // 预约中
}
struct LSUserStatusModel: HandyJSON {
    var statusname = ""
    var status = LSUserStatus.rest
    var leavetypename = ""
    var hours: Double = 0
    var starttime = ""
    var endtime = ""
    var shiftname = ""
    var workshift = ""
    var closingtime = ""
    var dispatchtime = ""
    var min = 0
    var billid = ""
    var tostoretime = ""
}


enum LSHomeProjectStatus: Int, HandyJSONEnum {
    case wait = 0
    case servicing = 1
    case finish = 2
    case subscribe = 7
    
    var backColor: UIColor {
        switch self {
        case .wait:
            return Color(hexString: "#FF0000")!
        case .servicing:
            return Color(hexString: "#00AAB7")!
        case .finish:
            return Color(hexString: "#5BC8B6")!
        case .subscribe:
            return Color(hexString: "#669AE6")!
        }
    }
    
    var statusString: String {
        switch self {
        case .wait:
            return "待服务"
        case .servicing:
            return "服务中"
        case .finish:
            return "已完成"
        case .subscribe:
            return "预约中"
        }
    }
    
    var statusImage: UIImage? {
        switch self {
        case .wait:
            return UIImage(named: "组 118")
        case .servicing:
            return UIImage(named: "组 119")
        case .finish:
            return UIImage(named: "组 119")
        case .subscribe:
            return UIImage(named: "组 119")
        }
    }
    
}
struct LSHomeProjectModel: HandyJSON {
    var bedid = ""
    var roomname = ""
    var starttime = ""
    var tid = ""
    var min = ""
    var billid = ""
    var refid = ""
    var projectid = ""
    var projectname = ""
    var createtime = ""
    var dispatchtime = ""
    var endtime = ""
    var handcardid = ""
    var roomid = ""
    var refname = ""
    var createname = ""
    var handcardno = ""
    var ctype = LSClockType.wheelClock
    var bedname = ""
    var updatetime = ""
    var status: LSHomeProjectStatus = .wait
    var amt:Double = 0
    var qty: Double = 0
    var jobid = ""
    var jprice: Double = 0
    var jmin = ""
    var images = ""
    var reftlid = ""
    var tostoretime = ""
    var name = ""
    var mobile = ""
    var custtype = LSCustomerType.common
    var reservemin = LSReserveTimeType.fifteen
    var remark = ""
    var sid = ""
    var tlid = ""
}

class LSGoodsTypeModel: HandyJSON {
    var level = 0
    var name = ""
    var typeid = ""
    var children: [LSGoodsTypeModel] = []
    
    var number = 0
    
    required init() {}
}


class LSGoodsModel: HandyJSON {
    var productid = ""
    var name = ""
    var imageurl = ""
    var typeid = ""
    var typename = ""
    var unit = ""
    var sellprice: Double = 0
    var itemstatus = "" // 商品状态 0上架 1 下架
    var stockqty = 0
    
    var number = 0
    
    required init() {}
}


class LSServiceModel: HandyJSON {
    var content = ""
    var serviceid = ""
    
    var number = 0

    required init() {}
}
