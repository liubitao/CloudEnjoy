//
//  LSNetworkConfig.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/22.
//   
//

import Foundation
import UIKit
import LSBaseModules

public struct LSNetworkConfig {
    public static var development: Bool = true
    
    public static var baseUrl: String = development ? "https://test.bypos.net/YxxSvr" : "https://yun.bypos.net/YxxSvr"
//    public static var baseUrl: String = development ? "http://192.168.8.43:9094/YxxSvr" : "https://yun.bypos.net/YxxSvr"
    public static var h5Url: String = development ? "https://test.bypos.net/YxxSvr" : "https://yun.bypos.net/YxxSvr"
    public static var imgUrl: String = "http://byyoupic.oss-cn-shenzhen.aliyuncs.com"

    public static var appUrl: String {self.baseUrl + "/app"}
    public static var uploadUrl: String {self.baseUrl + "/oss"}
   
    //默认下载保存地址（用户文档目录）
    public static let downloadDir: URL = {
        let directoryURLs = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)
        let dir = directoryURLs.first?.appendingPathComponent("downloadDir") ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let exist = FileManager.default.fileExists(atPath: dir.path)
            if !exist { // 判断是否已存在此文件夹,若不存在则创建文件夹
                // withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
                try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
        }
        return dir
    }()
    
    #if DEBUG
    static let timeout: TimeInterval =  60
    #else
    static let timeout: TimeInterval =  10
    #endif
    
    static let netwrokErrorData = "数据解析发生异常"
    static let netwrokError = "网络连接异常，请检查后重试".localized()
}
