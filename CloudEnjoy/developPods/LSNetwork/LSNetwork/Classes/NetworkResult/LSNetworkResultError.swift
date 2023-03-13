//
//  LSNetworkResultError.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/23.
//   
//

import Foundation
import HandyJSON

public enum LSNetworkResultError: Error {
    /// 通用错误
    case common(String?)
    /// 取消请求
    case cancelled(String?)
    /// 带错误码的错误
    case error(Int?, String?)
    
}

extension LSNetworkResultError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .common(let des):
            return des ?? "未知错误"
        case .cancelled(let des):
            return des ?? "取消操作"
        case .error(_, let des):
            return des ?? "未知错误"
        }
    }
    
}

extension LSNetworkResultError: LocalizedError {
    public var errorDescription: String? {
        return debugDescription
    }
}


public extension LSNetworkResultError {
    
    static let undefined: Int = -1
    
    public var code: Int {
        switch self {
        case .common(_):
            return LSNetworkResultError.undefined
        case .cancelled(_):
            return LSNetworkResultError.undefined
        case .error(let code, _):
            return code ?? LSNetworkResultError.undefined
        }
    }
    
}




