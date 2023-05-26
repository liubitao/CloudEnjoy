//
//  Date.swift
//  LSBaseModules
//
//  Created by liubitao on 2023/5/26.
//

import Foundation

extension Date {
    public func stringTime24(withFormat format: String = "yyyy/MM/dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
}

extension String {
    public func dateTime24(withFormat format: String = "yyyy/MM/dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
}
