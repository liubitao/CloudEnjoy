//
//  CommonDefine.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/8.
//

import Foundation
import LSNetwork

public func imgUrl(_ urlPath: String) -> URL?{
    return URL(string: "\(LSNetworkConfig.imgUrl)/\(urlPath)")
}
