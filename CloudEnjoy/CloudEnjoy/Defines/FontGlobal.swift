//
//  FontGlobal.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//

import Foundation
import CoreMedia
import UIKit

struct Font {
    
    // MARK: - 标记 PingFang
    private static let pingFangSCFontName = "PingFangSC"
    
    static func pingFangRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "\(pingFangSCFontName)-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pingFangMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "\(pingFangSCFontName)-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pingFangLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "\(pingFangSCFontName)-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pingFangSemibold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "\(pingFangSCFontName)-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
