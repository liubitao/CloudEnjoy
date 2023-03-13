import Foundation


public struct DiskCache: Cache {

	// MARK: - Properties
	private let directory: String
	private let fileManager = FileManager()
	private let queue = DispatchQueue(label: "com.ls.cache.disk-cache", attributes: .concurrent)

	// MARK: - Initializers

	public init?(directory: String) {
        // Ensure the directory exists
		var isDirectory: ObjCBool = true
        let cachesDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appendingPathComponent("Caches")
        let path = URL(string: cachesDirectory!)!.appendingPathComponent(directory).absoluteString ?? ""
		// Ensure the directory exists
		if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue {
			self.directory = path
			return
		}

		// Try to create the directory
		do {
			try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
			self.directory = path
		} catch {
            return nil
        }
	}

	// MARK: - Cache

	public func get(key: String, completion: @escaping ((Box?) -> Void)) {
		coordinate {
            let path = pathForKey(key)
			var value = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Box
			completion(value)
		}
	}

	public func set(key: String, value: Box, completion: (() -> Void)? = nil) {
		let path = pathForKey(key)
		let fileManager = self.fileManager

		coordinate(barrier: true) {
			if fileManager.fileExists(atPath: path) {
				do {
					try fileManager.removeItem(atPath: path)
				} catch {}
			}

			NSKeyedArchiver.archiveRootObject(value, toFile: path)
            completion?()
		}
	}

	public func remove(key: String, completion: (() -> Void)? = nil) {
		let path = pathForKey(key)
		let fileManager = self.fileManager

		coordinate {
			if fileManager.fileExists(atPath: path) {
				do {
					try fileManager.removeItem(atPath: path)
				} catch {}
			}
            completion?()
		}
	}

	public func removeAll(completion: (() -> Void)? = nil) {
		let fileManager = self.fileManager
		let directory = self.directory

		coordinate {
			guard let paths = try? fileManager.contentsOfDirectory(atPath: directory) else { return }

			for path in paths {
				do {
                    
                    try fileManager.removeItem(atPath: (directory as! NSString).appendingPathComponent(path))
				} catch { error
                    print(error)
                }
			}
            completion?()
		}
	}

	// MARK: - Private

	private func coordinate(barrier: Bool = false, block: @escaping () -> Void) {
		if barrier {
			queue.async(flags: .barrier, execute: block)
			return
		}

		queue.async(execute: block)
	}

	private func pathForKey(_ key: String) -> String {
		return (directory as NSString).appendingPathComponent(key)
	}
}
