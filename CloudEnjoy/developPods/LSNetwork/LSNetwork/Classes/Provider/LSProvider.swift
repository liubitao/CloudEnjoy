//
//  LSProvider.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/23.
//   
//

import Foundation
import Moya
import RxSwift
import CocoaLumberjack
import LSBaseModules


public extension LSProvider where Target: TargetType {
    public typealias NetworkCompletion = (LSNetworkResultModel) -> LSNetworkResultModel
    
    static var plugins: [PluginType] {
        return [LSCodePlugin.default]
    }
}

public class LSProvider<Target: LSTargetType>: MoyaProvider<Target> {
    public override init(endpointClosure: @escaping LSProvider<Target>.EndpointClosure = LSProvider.customEndpointMapping,
                  requestClosure: @escaping LSProvider<Target>.RequestClosure = LSProvider.defaultRequestMapping,
                  stubClosure: @escaping LSProvider<Target>.StubClosure = LSProvider.customStub,
                  callbackQueue: DispatchQueue? = nil,
                  session: Session = LSProvider<Target>.customAlamofireSession(),
                  plugins: [PluginType] = LSProvider<Target>.plugins,
                  trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
    
    public func lsRequest(_ target: Target,
                          callbackQueue: DispatchQueue? = .main,
                          completion: NetworkCompletion? = nil) -> Single<LSNetworkResultModel> {
        super.rx.request(target as! Target, callbackQueue: callbackQueue)
//            .refreshAuthenticationTokenIfNeeded(sessionServiceDelegate: self)
            .map { completion == nil ? $0 : completion!($0)}.observe(on: MainScheduler.instance)
    }
    
    public func lsDownload(_ target: Target,
                           redownload: Bool = false,
                           callbackQueue: DispatchQueue? = .main,
                           progress: ProgressBlock? = .none) -> Single<String> {
        if redownload == false && FileManager.default.fileExists(atPath: target.localLocation.path) {
            return Single.just(target.localLocation.path)
        }
        return super.rx.download(target as! Target, callbackQueue: callbackQueue, progress: progress).observe(on: MainScheduler.instance)
    }
    
    public func lsUpload(_ target: Target,
                           callbackQueue: DispatchQueue? = .main,
                           progress: ProgressBlock? = .none) -> Single<String>{
        return super.rx.upload(target as! Target, callbackQueue: callbackQueue, progress: progress)
//            .refreshAuthenticationTokenIfNeeded(sessionServiceDelegate: self)
            .map({ model in
                guard let data = model.data as? [String : Any],
                      let fileUrl = data["fileUrl"] as? String else{
                          return ""
                      }
                return fileUrl
            }).observe(on: MainScheduler.instance)
    }
    
    
    public func lsUploadFiles(_ target: Target,
                           callbackQueue: DispatchQueue? = .main,
                           progress: ProgressBlock? = .none) -> Single<[String]>{
        return super.rx.upload(target as! Target, callbackQueue: callbackQueue, progress: progress)
//            .refreshAuthenticationTokenIfNeeded(sessionServiceDelegate: self)
            .map({ model in
                if let data = model.data as? [String : Any],
                   let list = data["list"] as? [[String:Any]]{
                    var arr:[String] = []
                    for dict in list{
                        if let fileUrl = dict["fileUrl"] as? String {
                            arr.append(fileUrl)
                        }
                    }
                    return arr
                }
                return []
            }).observe(on: MainScheduler.instance)
    }
    
    
    
    
    public func lsUploadImages(_ target: Target, callbackQueue: DispatchQueue? = .main,
                               progress: ProgressBlock? = .none) -> Single<LSNetworkResultModel> {
        return super.rx.upload(target as! Target, callbackQueue: callbackQueue, progress: progress)
//            .refreshAuthenticationTokenIfNeeded(sessionServiceDelegate: self)
//            .map({ model in
//            if let data = model.data as? [String : Any],
//               let list = data["list"] as? [[String:Any]]{
//                var arr:[String] = []
//                for dict in list{
//                    if let fileUrl = dict["fileUrl"] as? String {
//                        arr.append(fileUrl)
//                    }
//                }
//                return arr
//            }
//            return []
//        })
            .observe(on: MainScheduler.instance)
    }
    
    /// 获取接口使用的时区 字符串
    private class var timeZone: String {
        let dateFormater = DateFormatter()
        if let identifier = Locale.preferredLanguages.first {
            dateFormater.locale = Locale.init(identifier: identifier)
        }
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss Z"
        let dateStr = dateFormater.string(from: Date())
        return dateStr.components(separatedBy: " ").last ?? "-0400"
    }
    
    
    public final class func customEndpointMapping(for target: Target) -> Endpoint {
        let url = URL(target: target).absoluteString
        var httpHeaderFields: [String: String] = ["spid": "1",
                                                  "sid": "1",
                                                  "client": "ios"]
                
        if let headers = target.headers {
            for dic in headers {
                httpHeaderFields[dic.key] = dic.value
            }
        }
        
        return Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: httpHeaderFields)
        
    }
    
    public final class func customStub(_ target: Target) -> Moya.StubBehavior {
        return target.stubBehavior
    }
    
    
    public final class func customAlamofireSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = LSNetworkConfig.timeout
        
        let session = Session.init(configuration: configuration, startRequestsImmediately: false, serverTrustManager: LSServerTrustPolicyManager())
        return session
    }  
}
