//
//  LSMoyaProvider+Rx.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/24.
//   
//

import Foundation
import Moya
import RxSwift


extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {
    func request(_ token: LSTargetType, callbackQueue: DispatchQueue? = nil, progress: ProgressBlock? = .none) -> Single<LSNetworkResultModel> {
        Single.create { [weak base] single in
            let cancellableToken = base?.request(token as! Base.Target, callbackQueue: callbackQueue, progress: progress) { result in
                switch result.resultModel {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
    
    func download(_ token: LSTargetType, callbackQueue: DispatchQueue? = nil, progress: ProgressBlock? = .none) -> Single<String> {
        Single.create { [weak base] single in
            let cancellableToken = base?.request(token as! Base.Target, callbackQueue: callbackQueue, progress: progress) { result in
                switch result {
                case .success(_):
                    single(.success(token.localLocation.path))
                case let .failure(error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
    
    func upload(_ token: LSTargetType, callbackQueue: DispatchQueue? = nil, progress: ProgressBlock? = .none) -> Single<LSNetworkResultModel> {
        Single.create { [weak base] single in
            let cancellableToken = base?.request(token as! Base.Target, callbackQueue: callbackQueue, progress: progress) { result in
                switch result.resultModel {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
