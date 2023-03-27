//
//  LSWorkbenchModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/11.
//

import Foundation
import HandyJSON
import SwifterSwift
import LSBaseModules


enum LSTimeSectionType: Int, CaseIterable {
    case today = 0
    case yesterday = 1
    case currentMonth = 2
    case lastMonth = 3
    case custom = 4
    
    var startdate: String {
        switch self {
        case .today:
            return Date().beginning(of: .day)?.string(withFormat: "yyyy-MM-dd hh:mm:ss") ?? ""
        case .yesterday:
            return Date().adding(.day, value: -1).beginning(of: .day)?.string(withFormat: "yyyy-MM-dd hh:mm:ss") ?? ""
        case .currentMonth:
            return Date().beginning(of: .month)?.string(withFormat: "yyyy-MM-dd hh:mm:ss") ?? ""
        case .lastMonth:
            return Date().adding(.month, value: -1).beginning(of: .month)?.string(withFormat: "yyyy-MM-dd hh:mm:ss") ?? ""
        case .custom:
            return Date().beginning(of: .day)?.string(withFormat: "yyyy-MM-dd hh:mm:ss") ?? ""
        }
    }
    
    var endDate: String {
        switch self {
        case .today:
            return Date().string(withFormat: "yyyy-MM-dd hh:mm:ss")
        case .yesterday:
            return Date().adding(.day, value: -1).end(of: .day)?.string(withFormat: "yyyy-MM-dd hh:mm:ss") ?? ""
        case .currentMonth:
            return Date().string(withFormat: "yyyy-MM-dd hh:mm:ss")
        case .lastMonth:
            return Date().adding(.month, value: -1).end(of: .month)?.string(withFormat: "yyyy-MM-dd hh:mm:ss") ?? ""
        case .custom:
            return Date().string(withFormat: "yyyy-MM-dd hh:mm:ss")
        }
    }
}


// 我的提成
struct LSRoyaltiesTotalModel: HandyJSON {
    var commissionsum = ""
    var list: [LSRoyaltiesItemModel] = []
    
}
struct LSRoyaltiesItemModel: HandyJSON {
    var name = ""
    var count = ""
    var commission = ""
    var selecttype = 0
}


struct LSRoyaltiesDetailsModel: HandyJSON {
    var id = ""
    var projectname = ""
    var amt = ""
    var ctypename = ""
    var commission = ""
    var roomname = ""
    var createtime = ""
}


// 我的钟数
struct LSFindMeClockNumModel: HandyJSON {
    var ptypelist: [LSFindMeClockNumItemTotalModel] = []
    var list: [LSFindMeClockNumItemModel] = []
}

struct LSFindMeClockNumItemTotalModel: HandyJSON {
    var ptype = 0       //0是主项 1是小项
    var sumdqty = 0     //点钟合计
    var sumlqty = 0     //轮钟合计
    var sumcqty = 0     //call钟合计
    var sumxqty = 0     //选钟合计
    var sumjqty = 0     //加钟合计
    var sumqty = 0      //总计
}

struct LSFindMeClockNumItemModel: HandyJSON {
    var name = ""
    var sumdqty = 0     //点钟合计
    var sumlqty = 0     //轮钟合计
    var sumcqty = 0     //call钟合计
    var sumxqty = 0     //选钟合计
    var sumjqty = 0     //加钟合计
}


// 我的工单
enum LSOrderServerStatus: String, CaseIterable, HandyJSONEnum {
    case none = ""
    case wait = "0"
    case ing = "1"
    case finish = "2"
    case exit = "3"
    
    var backColor: UIColor {
        switch self {
        case .none:
            return Color.white
        case .wait:
            return Color(hexString: "#669AE6")!
        case .ing:
            return Color(hexString: "#54C263")!
        case .finish:
            return Color(hexString: "#5BC8B6")!
        case .exit:
            return Color(hexString: "#EC8A8A")!
        }
    }
}

struct LSOrderServerModel: HandyJSON {
    var projectname = ""
    var roomname = ""
    var ctypename = ""
    var statusname = ""
    var status: LSOrderServerStatus = .wait
    var amt = ""
    var commission = ""
    var createtime = ""
}

// 会员

enum LSCardstatus: Int, HandyJSONEnum {
    case normal = 0
    case stop = 1
    case lose = 2
    case obsolete = 3
    case overdue = 4
    
    var statusString: String {
        switch self {
        case .normal:
            return "正常"
        case .stop:
            return "停用"
        case .lose:
            return "挂失"
        case .obsolete:
            return "作废"
        case .overdue:
            return "过期"
        }
    }
}
struct LSVipModel: HandyJSON {
    var name = ""   //会员姓名
    var vipno = ""  //会员卡号
    var typeid = "" //会员类别
    var typename = ""
    var mobile = "" //会员手机号
    var sex = 0    //会员性别
    var bsid = ""   //会员发卡门店
    var rfcode = "" //会员内码
    var password = ""//会员密码
    var writtenflag = false //会员签单选项 0 不允许 1允许
    var writtenamt = ""//会员签单金额
    var validflag = ""//有效期标识 1 有效期 0永久
    var validdate = ""//有效期日期
    var birthday = ""//会员生日
    var remark = ""//备注
    var jscardname = ""//介绍人
    var nowmoney = ""//当前余额
    var nowpoint = ""//当前积分
    var alladdmoney = ""//累计充值金额
    var allsalemoney = ""//累计消费金额
    var createtime = ""//创建时间
    var updatetime = ""// 更新时间
    var operid = ""//创建人
    var opername = ""//创建人名称
    var cardstatus: LSCardstatus = .normal //卡状态  1正常 0停用 2挂失 3作废 4过期
    var usesid = ""//使用门店
    var lastsaledate = ""//会员最后使用日期
    var status = ""//状态 0删除 1正常
    var capitalmoney = ""//本金
    var givemoney = ""//赠送金额
    var arrearages = ""//欠款金额
    var wxopenid = ""//绑定的微信openid
}


struct LSVipSumModel: HandyJSON {
    var nowmoney: Double = 0
    var nowpoint: Double = 0
}


// 预约
enum LSCustomerType: Int, CaseIterable, HandyJSONEnum {
    case common = 0
    case vip = 1
    
    var cutomerString: String {
        switch self {
        case .common:
            return "普通客户"
        case .vip:
            return "VIP客户"
        }
    }
}


enum LSClockType: Int, CaseIterable, HandyJSONEnum {
    case wheelClock = 1
    case optionClock = 2
    case oClock = 3
    case callClock = 4
    case addClock = 5
    
    var clockString: String {
        switch self {
        case .wheelClock:
            return "轮钟"
        case .oClock:
            return "选钟"
        case .optionClock:
            return "点钟"
        case .callClock:
            return "call钟"
        case .addClock:
            return "加钟"
        }
    }
}

enum LSReserveTimeType: Int, CaseIterable, HandyJSONEnum {
    case fifteen = 15
    case thirty = 30
    case sixty = 60
    
    var timeString: String {
        switch self {
        case .fifteen:
            return "15分钟"
        case .thirty:
            return "30分钟"
        case .sixty:
            return "60分钟"
        }
    }
    
    var reserveString: String {
        switch self {
        case .fifteen:
            return "15"
        case .thirty:
            return "30"
        case .sixty:
            return "60"
        }
    }
}


// 人员查询
struct LSSysUserModel: HandyJSON {
    var userid = ""
    var name = ""
    var imgurl = ""
    var code = ""
    var tlname = ""
}


// 房间类型
struct LSRoomTypeModel: HandyJSON {
    var name = ""
    var roomtypeid = ""
    var id = ""
}

struct LSOrderRoomModel: HandyJSON {
    var roomtypename = ""
//    var id = ""
    var roomid = ""
    var name = ""
}

struct LSProjectTypeModel: HandyJSON {
    var name = ""
    var projecttypeid = ""
}

struct LSOrderProjectModel: HandyJSON {
    var name = ""
    var projectid = ""
    var smin = ""
    var lprice: Double = 0
}


struct LSJSLevelModel: HandyJSON {
    var name = ""
    var tlid = ""
}

enum LSOrderStatus: Int, HandyJSONEnum {
    case hadYuyue = 0
    case wait = 1
    case cancel = 2
    case waitServer = 3
    case finish = 4
    
    var backColor: UIColor {
        switch self {
        case .hadYuyue:
            return Color.red
        case .wait:
            return Color(hexString: "#669AE6")!
        case .cancel:
            return Color(hexString: "#54C263")!
        case .waitServer:
            return Color(hexString: "#EC8A8A")!
        case .finish:
            return Color(hexString: "#2BC7AF")!
        }
    }
}

struct LSOrderModel: HandyJSON {
    var billid = ""
    var name = ""
    var mobile = ""
    var qty = ""
    var custtype = LSCustomerType.common
    var ctypename = ""
    var tostoretime = ""
    var reservemin = LSReserveTimeType.fifteen
    var refid = ""
    var refname = ""
    var remark = ""
    var roomname = ""
    var roomid = ""
    var projectid = ""
    var projectname = ""
    var statusname = ""
    var status = LSOrderStatus.hadYuyue
    var tid = ""
    var sid = ""
    var tlid = ""
    var createname = ""
    var ctype = LSClockType.wheelClock
    var tname = ""
}
