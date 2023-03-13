//
//  LSServerTrustPolicyManager.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/23.
//   
//

import Foundation
import Alamofire

class LSServerTrustPolicyManager: ServerTrustManager {

    init() {
        super.init(evaluators: [:])
    }

    override open func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        return DisabledTrustEvaluator()
    }
}
