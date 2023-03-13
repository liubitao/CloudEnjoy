public protocol Cache {
	func get(key: String, completion: @escaping ((Box?) -> Void))
	func set(key: String, value: Box, completion: (() -> Void)?)
	func remove(key: String, completion: (() -> Void)?)
	func removeAll(completion: (() -> Void)?)
}
