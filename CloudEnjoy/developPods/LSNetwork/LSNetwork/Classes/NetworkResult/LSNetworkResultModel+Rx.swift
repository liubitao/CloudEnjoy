//
//  LSNetworkResultModel+Rx.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/24.
//   
//

import Foundation
import RxSwift
import HandyJSON

public extension PrimitiveSequenceType where Trait == SingleTrait, Element == LSNetworkResultModel{
    /// 普通 Json 转 Model
    public func mapHandyModel <T : HandyJSON> (type : T.Type) -> Single<T?> {
        return self.map { (element) -> T? in
            let data = element.data
            let parsedElement : T?
            if let string = data as? String {
                parsedElement = T.deserialize(from: string)
            } else if let dictionary = data as? Dictionary<String , Any> {
                parsedElement = T.deserialize(from: dictionary)
            } else if let dictionary = data as? [String : Any] {
                parsedElement = T.deserialize(from: dictionary)
            } else {
                parsedElement = nil
            }
            return parsedElement
        }
    }
    
    // 将 Json 转成 模型数组
    public func mapHandyModelArray<T: HandyJSON>(type: T.Type) -> Single<[T]?> {
        return self.map { (element) -> [T]? in
            let data = element.data
            let parsedArray : [T?]?
            if let string = data as? String {
                parsedArray = [T].deserialize(from: string)
            } else if let array = data as? [Any] {
                parsedArray = [T].deserialize(from: array)
            } else {
                parsedArray = nil
            }
            return parsedArray?.flatMap{$0}
        }
    }
    
    
    
}
