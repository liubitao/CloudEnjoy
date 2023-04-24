//
//  LSUserModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/4.
//

import Foundation
import HandyJSON

public struct LSLoginModel: HandyJSON {
    public var rabbitport: String = "" //消息端口
    public var rabbitaddress: String = "" //消息服地址
    public var diff: Int = 0   //有效天数 >=0 还可以用 不然不能用
    public var token: String = "" //其他接口必传
    
    public var user: LSUserModel = LSUserModel()
    public var store: LSStoreModel = LSStoreModel()
    public var mach: LSMachModel = LSMachModel()
    
    public init(){
        
    }
    
    public static var shared: LSLoginModel = LSLoginModel.deserialize(from: LoginDataCache.get(key: "LoginInfo") as? String) ?? LSLoginModel()
}

public enum LSSex:Int, HandyJSONEnum {
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

public struct LSMachModel: HandyJSON {
    public var code: String = ""
    
    public init(){}
}

public struct LSUserModel: HandyJSON{
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
    public init(){}
}

public struct LSStoreModel: HandyJSON {
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
    public init(){}
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

public func appIsLogin() -> Bool {
    return LSLoginModel.shared.token.count > 0
}

