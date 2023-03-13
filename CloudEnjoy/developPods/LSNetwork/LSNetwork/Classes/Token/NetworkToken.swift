//
//  NetworkToken.swift
//  LSNetwork
//
//  Created by liubitao on 2021/12/28.
//

import Foundation
import RxSwift
import CocoaLumberjack
import Moya
import HandyJSON
import Accessibility
import LSBaseModules


// 定义一个协议
public protocol SessionProtocol {
    // 刷新token的协议
    func getTokenRefreshService() -> Single<Bool>
    // 获取token失败的协议
    func didFailedToRefreshToken()
    // token刷新成功的协议
    func tokenDidRefresh (tokenModel : LSToken)
    
}

public extension Notification.Name {
    static var TokenRefreshed: Notification.Name = .init(rawValue: "LSNetwork.TokenRefreshed")
}

private var dispose: Disposable?
private var isRefreshing = false
private let conditionLock = NSConditionLock(condition: 2)
private var networkError: Error?

public extension PrimitiveSequenceType where Trait == SingleTrait, Element == LSNetworkResultModel {
    public func refreshAuthenticationTokenIfNeeded(sessionServiceDelegate : SessionProtocol) -> Single<LSNetworkResultModel> {
        return self.primitiveSequence.observe(on: ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global())).retry { responseFromFirstRequest in
            responseFromFirstRequest.flatMap { originalRequestResponseError -> PrimitiveSequence<SingleTrait, Element> in
                if case LSNetworkResultError.error(LSNetworkResultModel.Code.refreshToken.rawValue, let accessToken) = originalRequestResponseError {
                    do {
                        if isRefreshing == false && accessToken == LSToken.shared.accesstoken {
                            conditionLock.unlock(withCondition: 2)
                            isRefreshing = true
                            dispose?.dispose()
                            dispose = sessionServiceDelegate.getTokenRefreshService().subscribe { _ in
                                networkError = nil
                            } onFailure: { error in
                                networkError = error
                            } onDisposed: {
                                isRefreshing = false
                                conditionLock.unlock(withCondition: 1)
                            }
                        }
                    }
                    conditionLock.lock(whenCondition: 1)
                    defer {
                        conditionLock.unlock(withCondition: 1)
                    }
                    if let networkError = networkError{
                        return Single.error(networkError)
                    }
                    return self.primitiveSequence.retry(1)
                    
                }else {
                    return Single.error(originalRequestResponseError)
                }
            }
        }
    }
}


// 创建一个结构体，遵循SessionProtocol 协议
extension LSProvider: SessionProtocol {
    public func getTokenRefreshService() -> Single<Bool> {
        let refreshToken = LSToken.shared.refreshToken
        guard !refreshToken.isEmpty else{
            return Single.error(LSNetworkResultError.error(LSNetworkResultModel.Code.reLogin.rawValue, "请重新登录"))
        }
        // return 刷新token的rx方法
        return LSProvider<LSTokenApi>().lsRequest(LSTokenApi.refreshToken).observe(on: MainScheduler.instance)
            .catchError {[weak self] tokeRefreshRequestError -> Single<LSNetworkResultModel> in
                self?.didFailedToRefreshToken()
                if let lucidErrorOfTokenRefreshRequest = tokeRefreshRequestError as? LSNetworkResultError {
                    // 并返回失败
                    return Single.error(lucidErrorOfTokenRefreshRequest)
                }
                // 返回失败
                return Single.error(tokeRefreshRequestError)
            }.flatMap {[weak self] resultModel -> Single<Bool> in
                // 如果请求新的接口筛选成功 那么刷新token成功
                // 回调成功以后拿到的json，并在sessionServiceDelegate 协议的 tokenDidRefresh 方法中 保存这个新的token
                if let tokenModel = LSToken.deserialize(from: resultModel.data as? [String : Any], designatedPath: nil) {
                    LSToken.shared = tokenModel
                    return Single.just(true)
                }
                return Single.error(LSNetworkResultError.error(LSNetworkResultModel.Code.reLogin.rawValue, "请重新登录"))
            }
    }
    
    public func didFailedToRefreshToken() {
        LSPrintLog("didFailedToRefreshToken")
        NotificationCenter.default.post(name: Notification.Name("LSNetwork.RELOGIN"), object: nil)
        LSToken.clearToken()
    }
    
    public func tokenDidRefresh(tokenModel: LSToken) {}
    
}

public class LSToken: HandyJSON {
    public var accesstoken: String = ""
    public var refreshToken: String = ""
    public var deviceId: String = ""
    public var appId: String = ""
    required public init(){}
    public static var shared: LSToken {
        get {
            if let s = _shared {
                return s
            }
            let db = LSToken.loadFromDB()
            _shared = db
            return db
        }
        set {
            _shared = newValue
            newValue.storeToDB()
        }
    }
    
    private static var _shared: LSToken?
    
    internal var dbModel: LSTokenModel {
        let db = LSTokenModel()
        db.accesstoken = self.accesstoken
        db.refreshToken = self.refreshToken
        db.deviceId = self.deviceId
        db.appId = self.appId
        return db
    }
    
    private func storeToDB() {
//        LSRealmHelper.addOrUpdateObjectNoSingle(object: dbModel)
    }
    
    internal static func creat(with dbModel: LSTokenModel) -> LSToken{
        var token = LSToken()
        token.accesstoken = dbModel.accesstoken
        token.refreshToken = dbModel.refreshToken
        token.appId = dbModel.appId
        token.deviceId = dbModel.deviceId
        return token
    }
    
    private static func loadFromDB() -> LSToken {
//        let token = LSRealmHelper.queryObjectNoSingle(objectClass: LSTokenModel.self).first.map { creat(with: $0) }
//        return token ?? LSToken()
        return LSToken()
    }
    
    public static func clearToken(){
//        LSRealmHelper.clearTableNoSingle(object: LSTokenModel.self)
    }
}

class LSTokenModel {
    var accesstoken: String = ""
    var refreshToken: String = ""
    var deviceId: String = ""
    var appId: String = ""
}


extension LSTokenApi.APIPath {
    static let refreshToken = "customer/refreshToken"
}
enum LSTokenApi {
    struct APIPath {}
    case refreshToken  // 刷新token
}

extension LSTokenApi: LSTargetType{
    var path: String {
        switch self {
        case .refreshToken:
            return APIPath.refreshToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshToken:
            return .get
        }
    }
    
    var originParams: [String : Any]? {
        switch self {
        case let .refreshToken:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .refreshToken:
            return ["refreshToken": LSToken.shared.refreshToken]
        }
    }
}


