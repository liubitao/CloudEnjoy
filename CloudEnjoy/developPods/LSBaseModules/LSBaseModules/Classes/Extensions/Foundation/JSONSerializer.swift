//
//  JSONSerializer.swift
//  LSBaseModules
//
//  Created by liubitao on 2023/3/22.
//

import Foundation

public extension Collection {
    func ls_toJSONString(prettyPrint: Bool = false) -> String? {
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let jsonData: Data
                if prettyPrint {
                    jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
                } else {
                    jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
                }
                return String(data: jsonData, encoding: .utf8)
            } catch let error {
                print(error)
            }
        } else {
            print("is not a valid JSON Object")
        }
        return nil
    }
}
