//  LSHealthApi.swift
//  Haylou_Fun
//
//  Created by     on 2022/05/26
//   
//


public extension Int {
    var UInt32Value: UInt32 {
        if self < 0 {
            #if DEBUG
            fatalError("Int-->UInt32 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt32 越界:\(self)")
            return 0
            #endif
        }
        if self > UInt32.max {
            #if DEBUG
            fatalError("Int-->UInt32 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt32 越界:\(self)")
            return UInt32.max
            #endif
        }
        
        return UInt32(self)
    }
    
    var Int32Value: Int32 {
        
        if self > Int32.max {
            #if DEBUG
            fatalError("Int-->UInt32 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt32 越界:\(self)")
            return Int32.max
            #endif
        }
        return Int32(self)
    }
    
    var UInt16Value: UInt16 {
        if self < 0 {
            #if DEBUG
            fatalError("Int-->UInt16 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt16 越界:\(self)")
            return 0
            #endif
        }
        if self > UInt16.max {
            #if DEBUG
            fatalError("Int-->UInt16 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt16 越界:\(self)")
            return UInt16.max
            #endif
        }
        
        return UInt16(self)
    }
    
    var Int16Value: Int16 {
        
        if self > Int16.max {
            #if DEBUG
            fatalError("Int-->UInt16 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt16 越界:\(self)")
            return Int16.max
            #endif
        }
        return Int16(self)
    }
    
    var UInt8Value: UInt8 {
        if self < 0 {
            #if DEBUG
            fatalError("Int-->UInt8 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt8 越界:\(self)")
            return 0
            #endif
        }
        if self > UInt8.max {
            #if DEBUG
            fatalError("Int-->UInt8 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt8 越界:\(self)")
            return UInt8.max
            #endif
        }
        
        return UInt8(self)
    }
    
    var Int8Value: Int8 {
        
        if self > Int8.max {
            #if DEBUG
            fatalError("Int-->UInt8 越界:\(self)")
            #else
            LSPrintLog("Int-->UInt8 越界:\(self)")
            return Int8.max
            #endif
        }
        return Int8(self)
    }
}



