//
//  LSTargetType.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/22.
//   
//

import Foundation
import Alamofire
import Moya
import LSBaseModules


public protocol LSTargetType: TargetType {
    var originParams: [String: Any]? {get}
    
    /// 是否走测试数据 默认 .never
    var stubBehavior: Moya.StubBehavior { get }
    
    /// 下载到本地文件的url
    var localLocation: URL {get}
}
/// 请求的默认配置
public extension LSTargetType {

    var baseURL: URL {URL(string: LSNetworkConfig.appUrl)!}
    
    var path: String {""}
    
    var method: Moya.Method {.post}
    
    var task: Task {
        var params = self.originParams ?? [String: Any]()
        if !LSLoginModel.shared.token.isEmpty {
            params["token"] = LSLoginModel.shared.token
        }
        params["sign"] = "83690002"
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {nil}
    
    /// 是否走测试数据 默认 .never
     var stubBehavior: Moya.StubBehavior { .never }
    /// 下载到本地文件的url
    var localLocation: URL { return LSNetworkConfig.downloadDir}
    
    var originParams: [String: Any]? {nil}
}
