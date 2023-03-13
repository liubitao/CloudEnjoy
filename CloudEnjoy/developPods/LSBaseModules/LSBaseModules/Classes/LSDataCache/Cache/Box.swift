public final class Box: NSObject, NSCoding {
   
    

	// MARK: - Properties

	let value: Any

	// MARK: - Initializers

	init(_ value: Any) {
		self.value = value
	}
    
    public func encode(with coder: NSCoder) {
        coder.encode(value, forKey: "value")
    }
    
    public required convenience init?(coder: NSCoder) {
        let value = coder.decodeObject(forKey: "value")
        self.init(value)
    }
    
}
