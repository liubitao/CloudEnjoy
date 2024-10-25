//
//  LSUserModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/4.
//

import Foundation
import SmartCodable

public class LSLoginModel: SmartCodable {
    public var rabbitport: String = "" //消息端口
    public var rabbitaddress: String = "" //消息服地址
    public var diff: Int = 0   //有效天数 >=0 还可以用 不然不能用
    public var token: String = "" //其他接口必传
    
    public var user: LSUserModel = LSUserModel()
    public var store: LSStoreModel = LSStoreModel()
    public var mach: LSMachModel = LSMachModel()
    public var parameters: LSParametersModel = LSParametersModel()
    
    public var rolemap: [LSRoleType] = []
    
    
    required public init(){
        
    }
    
    struct SmartRolemapTransformer: ValueTransformable {
        typealias JSON = [String: String]
        typealias Object = [LSRoleType]
        
        init() {}
        
        func transformFromJSON(_ value: Any) -> [LSRoleType]? {
            guard let roleMaps = value as? [String : String] else{
                return []
            }
            return roleMaps.keys.map{LSRoleType(rawValue: $0) ?? .other}
        }
        
        func transformToJSON(_ value: [LSRoleType]) -> [String: String]? {
            guard value.count > 0 else{
                return [:]
            }
            return value.reduce([String : String]()){$0.merging([$1.rawValue : $1.title]){$0 + $1}}
        }
    }

    public static func mappingForValue() -> [SmartValueTransformer]? {
        [
            CodingKeys.rolemap <--- SmartRolemapTransformer(),
        ]
    }
    
    
    public static var shared: LSLoginModel = LSLoginModel.deserialize(from: LoginDataCache.get(key: "LoginInfo") as? String) ?? LSLoginModel()
}

public enum LSSex:Int, SmartCaseDefaultable {
    case woman = 0
    case man = 1
    
    public var text: String {
        switch self {
        case .woman:
            return "女"
        case .man:
            return "男"
        }
    }
}

public class LSMachModel: SmartCodable {
    public var code: String = ""
    
    required public init(){}
}

public class LSUserModel: SmartCodable{
    public var spid = 0
    public var sid = 0
    public var headimg: String = ""    //头像
    public var userid: String = ""     //当前登录技师唯一标识
    public var branchname: String = "" //部门
    public var name: String = ""       //技师名字
    public var code: String = ""       //技师编号
    public var client: String = ""     //（通用的参数）
    public var mobile: String = ""     //手机号码
    public var sex: LSSex = .woman     //性别
    public var tlname: String = ""      //技师等级
    public var jobid: String = ""
    required public init(){}
}

public class LSStoreModel: SmartCodable {
    public var spid = 0
    public var sid = 0
    public var id: String = ""
    public var starttime: String = ""  //营业开始时间
    public var account: String = ""    //商户号
    public var name: String = ""       //门店名称
    public var linkaddr: String = ""   //门店地址
    public var linkman: String = ""    //负责人
    public var linkmobile: String = "" //联系电话
    public var code: String = ""       //门店编号
    public var lat: Double = 0          //纬度
    public var lng: Double = 0          //经度
    public var trade: String = "" // 商家门店类型
    
    required public init(){}
}

public enum OperationModeType: Int, SmartCaseDefaultable {
    case roomAndBed = 0 //房间加床位
    case roomAndHandCard = 1 //房间加手牌
    case handCard = 2 //手牌模式
}
public class LSParametersModel: SmartCodable {
    public var NextBellReminder = 0 //项目服务中还剩多少分钟的时候提示
    public var TimeoutReminder = 0  //超时每隔几分钟提醒
    public var MakeAppointmentReminder = 0 //项目未上钟每多少分钟的提示一次，根据派工时间和当前时间校验
    public var OperationMode: OperationModeType = .roomAndBed //0是房间模式 1是房间加手牌 2是手牌模式
    public var OverStockPerSale = 0 //1 允许销售，不提示   2 允许销售，提示  3 不允许销售，并提示
    public var addClockDefTime: Double = 0 // 加钟默认钟数
    public var ShopStartTime: String = "" // 开门营业时间
    public var ShopEndTime: String = "" // 关门营业时间
    
    public var showRoom: Bool {
        self.OperationMode != .handCard
    }
    required public init(){}
}

public enum LSRoleType: String, SmartCaseDefaultable {
    
    case royalties = "0201" //我的提成
    case clocks = "0202" //我的钟数
    case workorder = "0203" //我的工单
    case userquery = "0204" //会员查询
    case jsRank = "0211" //技师排位
    case orderSummary = "0210" //工单汇总
    
    case order = "0205" //预约查询
    case addOrder = "0206" //新增预约
    case sendWork = "0209" //派工
    
    case clockin = "0207" //打卡
    case leave = "0208" //员工请假
    
    case other = "" //其他
    
    public var title: String {
        switch self {
        case .royalties: return "我的提成"
        case .clocks: return "我的钟数"
        case .workorder: return "我的工单"
        case .userquery: return "会员查询"
        case .jsRank: return "技师排位"
        case .orderSummary: return "工单汇总"
        case .order: return "预约查询"
        case .addOrder: return "新增预约"
        case .sendWork: return "派工"
        case .clockin: return "员工打卡"
        case .leave: return "员工请假"
        case .other: return "其他"
        }
    }
}


public func userModel() -> LSUserModel {
    return LSLoginModel.shared.user
}

public func storeModel() -> LSStoreModel {
    return LSLoginModel.shared.store
}

public func machModel() -> LSMachModel {
    return LSLoginModel.shared.mach
}

public func parametersModel() -> LSParametersModel {
    return LSLoginModel.shared.parameters
}


public func rolemapModel() -> [LSRoleType] {
    return LSLoginModel.shared.rolemap
}

public func appIsLogin() -> Bool {
    return LSLoginModel.shared.token.count > 0
}

