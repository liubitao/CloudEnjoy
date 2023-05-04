//
//  LSDataCache.swift
//  LSBaseModules
//
//  Created by liubitao on 2022/4/11.
//

import Foundation
import CryptoKit
import RxSwift

enum LSDataCacheType {
    case loginAccountInfo //当前登录账号信息
    case appInfo     //当前app的协议
    case loginAccount   //缓存登录的账号
    
    var mainCachePath: String {
        switch self {
        case .loginAccountInfo:
            return "loginAccountInfo"
        case .appInfo:
            return "appInfo"
        case .loginAccount:
            return "loginAccount"
        }
    }
}

public let LoginDataCache  = LSDataCache.init(cacheType: .loginAccountInfo)
public let AppDataCache = LSDataCache.init(cacheType: .appInfo)
public let LoginAccountCache = LSDataCache.init(cacheType: .loginAccount)


public struct LSDataCache {
    var cacheType: LSDataCacheType!
    var cache: MultiCache!
    let semaphore = DispatchSemaphore.init(value: 0)
    
    init(cacheType: LSDataCacheType) {
        self.cacheType = cacheType
        
        let memoryCache = AnyCache.init(MemoryCache.init())
        let diskCache = AnyCache.init(DiskCache.init(directory: cacheType.mainCachePath)!)
        self.cache = MultiCache.init(caches: [memoryCache, diskCache])
    }
    
    public func set(key: String, value: Any?) {
        if value == nil {
            self.remove(key: key)
        }else {
            cache.set(key: key, value: Box.init(value))
        }
    }
    
    public func get(key: String) -> Any? {
        var value: Any? = nil
        cache.get(key: key) { box in
            if let box = box {
                value = box.value
            }
            semaphore.signal()
        }
        semaphore.wait()
        return value
    }
    
    public func remove(key: String) {
        cache.remove(key: key) {
            semaphore.signal()
        }
        semaphore.wait()
    }
                
    public func removeAll() {
        cache.removeAll {
            semaphore.signal()
        }
        semaphore.wait()
    }
}


extension LSDataCache {
    public func setItem<T: Encodable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        self.set(key: key, value: encoded)
    }
    
    public func getItem<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.get(key: key) as? Data else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            debugPrint("Couldnt find key")
            return nil
        }
        return object
    }
}

