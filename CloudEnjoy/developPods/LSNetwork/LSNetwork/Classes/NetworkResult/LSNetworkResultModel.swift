//
//  LSNetworkResultModel.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/23.
//   
//

import Foundation
import CoreMedia
import Moya
import RxSwift
import Result
import SmartCodable

extension Result where Value: Moya.Response {
    var resultModel: Result<LSNetworkResultModel, LSNetworkResultError> {
        switch self {
        case let .success(response):
            do {
                let dictJson = (try response.mapJSON()) as? [String: Any] ?? [:]
                let resultModel = LSNetworkResultModel.deserialize(from: dictJson)
                if let resultModel = resultModel, resultModel.retcode.isSuccess {
                    return .success(resultModel)
                }else {
                    let msg = ((resultModel?.retmsg.isEmpty ?? true) ? LSNetworkConfig.netwrokErrorData : resultModel!.retmsg)
                    let errorCode = resultModel?.retcode.rawValue ?? LSNetworkResultModel.Code.unknown.rawValue
                    return .failure(LSNetworkResultError.error(errorCode, msg))
                }
            }catch {
                return .failure(LSNetworkResultError.common(LSNetworkConfig.netwrokError))
            }
        case let .failure(error):
            return .failure(LSNetworkResultError.common(LSNetworkConfig.netwrokError))
        }
    }
}



public struct LSNetworkResultModel: SmartCodable {
    @SmartAny
    public var data: Any?
    public var retcode: Code = .unknown
    public var retmsg: String = ""
    
    public init(){}
}

public struct LSNetworkListModel<T: SmartCodable>: SmartCodable {
    public var total = 0   //总数据
    public var pages = 0   //总页数
    public var pageNum = 0 //当前页数
    public var list = [T]()
    public var isLastPage = 0
    @SmartAny
    public var sumdata: Any?
    public init(){}
}



extension LSNetworkResultModel {
    /// 网络请求状态码
    public enum Code: Int, SmartCaseDefaultable {
        /// 未知，默认值
        case unknown = -1
        /// 成功
        case success = 0
        /// token过期
        case refreshToken = -2
        /// 重新登录
        case reLogin = 100001002
        
        /// 判断网络请求是否成功
        var isSuccess: Bool {self == .success}
    }
}


