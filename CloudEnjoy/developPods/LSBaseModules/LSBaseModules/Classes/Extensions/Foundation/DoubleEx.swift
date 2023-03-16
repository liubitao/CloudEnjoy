////  DoubleEx.swift
//  Haylou_Fun
//
//  Created by 胡烽 on 2021/12/28
//  Copyright © 2021 lieSheng. All rights reserved.
//

extension Double {
    public var date: Date {
        return Date(timeIntervalSince1970: self)
    }
    
    /// 四舍五入 保留places位小数
    /// - Parameter places: 保留几位小数
    /// - Returns: 结果
    public func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    /// 向上 保留places位小数
    /// - Parameter places: 保留几位小数
    /// - Returns: 结果
    public func ceilTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.up) / divisor
    }
    
    /// 向下 保留places位小数
    public func floorTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.down) / divisor
    }
    
    /// 四舍五入 保留places位小数
    public func roundString(retain count: Int) -> String {
        return String(format: "%.0\(count)f", self.roundTo(places: count))
    }
    
    /// 向上取整
    public func ceilString(retain count: Int) -> String {
        
        return String(format: "%.0\(count)f", self.ceilTo(places: count))
    }
    
    /// 向下取整 保留几位
    public func floorString(retain count: Int) -> String {
        
        return String(format: "%.0\(count)f", self.floorTo(places: count))
    }
    
    /// 获取字符串 保留小数点后count位 四舍五入
    ///
    /// - Parameter count: 保留小数点后几位
    /// - Returns: 转换后的字符串
    public func stringValue(retain count: Int) -> String{

        return String(format: "%.0\(count)f", self.roundTo(places: count))
    }
}
