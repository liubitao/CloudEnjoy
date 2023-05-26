//
//  LSUserApi.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/4.
//

import Foundation
import LSNetwork
import Moya
import LSBaseModules

extension LSUserAPI.APIPath {
    static let login = "yxxlogin"
    static let updatepwd = "sysuser/updatepwd"
    static let getCode = "getcode"
    static let jcMobileCode = "sysuser/jcMobileCode"
    static let updateMobile = "sysuser/updateMobile"
    
    static let getUserImgList = "sysuser/getUserImgList"
    static let delUserImg = "sysuser/delUserImg"
    static let updateUserImg = "sysuser/updateUserImg"
    
    static let userUpdate = "sysuser/update"

}

enum LSUserAPI {
    struct APIPath {}
    
    case login(account: String?,
               mobile: String?,
               code: String?,
               pwd: String?)
    case updatePwd(userid: String,
                   pwd: String,
                   newpwd: String,
                   newpwd2: String)
    case getCode(phone: String,
                 smstype: String)   //1获取注册验证码 2.获取修改密码验证码 3.获取修改手机号验证码 4.修改支付参数 6.忘记密码
    case jcMobileCode(mobile: String,
                      code: String)
    case updateMobile(userid: String,
                      mobile: String,
                      code: String,
                      newmobile: String)
    case getUserImgList
    case delUserImg(imgids: [String])
    case updateUserImg(imgid: String)
    
    case userUpdate(headimg: String)
    
}


extension LSUserAPI: LSTargetType{
    var path: String {
        switch self {
        case .login:
            return APIPath.login
        case .updatePwd:
            return APIPath.updatepwd
        case .getCode:
            return APIPath.getCode
        case .jcMobileCode:
            return APIPath.jcMobileCode
        case .updateMobile:
            return APIPath.updateMobile
        case .getUserImgList:
            return APIPath.getUserImgList
        case .delUserImg:
            return APIPath.delUserImg
        case .updateUserImg:
            return APIPath.updateUserImg
        case .userUpdate:
            return APIPath.userUpdate
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var originParams: [String : Any]? {
        switch self {
        case let .login(account, mobile, code, pwd):
            var params:[String: String] = ["client": "JS",
                                           "machserial": "ssssff",
                                           "version": UIApplication.shared.version.unwrapped(or: ""),
                                           "pwd": pwd.unwrapped(or: "")]
            if let account = account {
                params["account"] = account
            }
            if let mobile = mobile {
                params["mobile"] = mobile
            }
            if let code = code {
                params["code"] = code
            }
            return params
        case let .updatePwd(userid, pwd, newpwd, newpwd2):
            return ["userid": userid,
                    "pwd": pwd,
                    "newpwd": newpwd,
                    "newpwd2": newpwd2]
        case let .getCode(phone, smstype):
            return ["phone": phone,
                    "smstype": smstype]
        case let .jcMobileCode(mobile, code):
            return ["mobile": mobile,
                    "code": code]
        case let .updateMobile(userid, mobile, code, newmobile):
            return ["userid": userid,
                    "mobile": mobile,
                    "code": code,
                    "newmobile": newmobile]
        case .getUserImgList:
            return ["userid": userModel().userid]
        case let .delUserImg(imgids):
            return ["userid": userModel().userid,
                    "imgids": imgids.joined(separator: ",")]
        case let .updateUserImg(imgid):
            return ["userid": userModel().userid,
                    "imgid": imgid]
        case let .userUpdate(headimg):
            return ["userid": userModel().userid,
                    "headimg": headimg]
        }
    }
}
