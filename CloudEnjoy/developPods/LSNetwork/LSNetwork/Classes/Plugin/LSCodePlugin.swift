//
//  LSCodePlugin.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/23.
//   
//

import Foundation
import Moya
import CocoaLumberjack
import SwifterSwift
import RxSwift
import LSBaseModules

public final class LSCodePlugin: PluginType {
    private let showLoginSubject = PublishSubject<Void>.init()

    static let `default`: LSCodePlugin = LSCodePlugin()
    
    private var bag = DisposeBag()
    init() {
        self.showLoginSubject.debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)
        .subscribe { _ in
            NotificationCenter.default.post(name: Notification.Name("LSNetwork.RELOGIN"), object: nil)
        }.disposed(by: bag)
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType){
//        switch result {
//        case .success(let response):
//                LSPrintLog("success-----\n\(response.lsDebugDescription)\n")
//        case let .failure(error):
//                LSPrintLog("fail--------\(error)>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
//        }
    }

    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        switch result.resultModel {
        case .success(_):
            return result
        case let .failure(error):
            guard let error = error as? LSNetworkResultError else {return result}
            switch LSNetworkResultModel.Code(rawValue: error.code) {
            case .unknown, .none:
                return result
            case .success:
                return result
            case .reLogin, .refreshToken:
                self.showLoginSubject.onNext(())
                return result
            default:
                return result
            }
        }
    }
    
}

// MARK: ------------------------- Show Login
extension Moya.Response {
    var lsDebugDescription: String {

        let requestDescription = request.map { "\($0.httpMethod ?? "GET") \($0)"} ?? "nil"
        let requestBody = request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let d: Data? = data
        let responseBody = d.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let headers = "\(request?.allHTTPHeaderFields ?? [:])"
        let status = response?.statusCode ?? -1

        return """
        [Request]: \(requestDescription)
        [Headers]: \(headers)
        [Request Body]: \n\(requestBody)
        [Response Status]: \(status)
        [Response Body]: \n\(responseBody)
        """

        return ""
    }
}
