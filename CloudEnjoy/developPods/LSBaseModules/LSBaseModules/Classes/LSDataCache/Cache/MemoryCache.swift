#if os(iOS) || os(tvOS)
	import UIKit
#else
	import Foundation
#endif

public final class MemoryCache: Cache {

	// MARK: - Properties

	private let storage = NSCache<NSString, Box>()

	// MARK: - Initializers

	#if os(iOS) || os(tvOS)
		public init(countLimit: Int? = nil, automaticallyRemoveAllObjects: Bool = false) {
			storage.countLimit = countLimit ?? 0

//			if automaticallyRemoveAllObjects {
//				let notificationCenter = NotificationCenter.default
//				notificationCenter.addObserver(storage, selector: #selector(type(of: storage).removeAllObjects), name: UIApplication.didEnterBackgroundNotification, object: nil)
//				notificationCenter.addObserver(storage, selector: #selector(type(of: storage).removeAllObjects), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
//			}
		}
	#else
		public init(countLimit: Int? = nil) {
			storage.countLimit = countLimit ?? 0
		}
	#endif

	// MARK: - Cache

	public func set(key: String, value: Box, completion: (() -> Void)? = nil) {
		storage.setObject(value, forKey: key as NSString)
		completion?()
	}

	public func get(key: String, completion: @escaping ((Box?) -> Void)) {
		let box = storage.object(forKey: key as NSString)
		completion(box)
	}

	public func remove(key: String, completion: (() -> Void)? = nil) {
		storage.removeObject(forKey: key as NSString)
		completion?()
	}

	public func removeAll(completion: (() -> Void)? = nil) {
		storage.removeAllObjects()
		completion?()
	}
	
	// MARK: - Synchronous
	
	public subscript(key: String) -> Box? {
		get {
			return (storage.object(forKey: key as NSString))
		}
		
		set(newValue) {
			if let newValue = newValue {
				storage.setObject(newValue, forKey: key as NSString)
			} else {
				storage.removeObject(forKey: key as NSString)
			}
		}
	}
}
