//
//  LSUserServer.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/4.
//

import Foundation
import LSNetwork
import RxSwift
import LSBaseModules
import HandyJSON

class LSUserServer {
    static let provider = LSProvider<LSUserAPI>()
    
    static func login(account: String? = nil,
                      mobile: String? = nil,
                      code: String? = nil,
                      pwd: String?) -> Single<LSLoginModel?>{
        return provider.lsRequest(.login(account: account, mobile: mobile, code: code, pwd: pwd!)).mapHandyModel(type: LSLoginModel.self).do(onSuccess: { model in
            guard let model = model else {
                return
            }
            LoginDataCache.set(key: "LoginInfo", value: model.toJSONString())
            AppDataCache.set(key: "storeType", value: model.store.trade)
            LSLoginModel.shared = model
        })
    }
    
    static func updatePwd(userid: String,
                         pwd: String,
                         newpwd: String,
                         newpwd2: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.updatePwd(userid: userid, pwd: pwd, newpwd: newpwd, newpwd2: newpwd2))
    }
    
    static func getCode(phone: String,
                        smstype: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.getCode(phone: phone, smstype: smstype))
    }
    
    static func jcMobileCode(mobile: String,
                             code: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.jcMobileCode(mobile: mobile, code: code))
    }
    
    static func updateMobile(userid: String,
                             mobile: String,
                             code: String,
                             newmobile: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.updateMobile(userid: userid, mobile: mobile, code: code, newmobile: newmobile))
    }
    
    static func getUserImgList() -> Single<[LSPhotoModel]?> {
        return provider.lsRequest(.getUserImgList).mapHandyModelArray(type: LSPhotoModel.self)
    }
    
    static func delUserImg(imgids: [String]) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.delUserImg(imgids: imgids))
    }
    
    static func updateUserImg(imgid: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.updateUserImg(imgid: imgid))
    }
    
    static func userUpdate(headimg: String) -> Single<LSNetworkResultModel> {
        return provider.lsRequest(.userUpdate(headimg: headimg))
    }
}
