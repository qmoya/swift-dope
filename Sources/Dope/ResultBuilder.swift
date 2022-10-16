import Foundation

public protocol TypedValuable {
	func toTypedValue() -> TypedValue
}

extension String: TypedValuable {
	public func toTypedValue() -> TypedValue {
		.string(self)
	}
}

extension Int: TypedValuable {
	public func toTypedValue() -> TypedValue {
		.int(self)
	}
}

extension UInt: TypedValuable {
	public func toTypedValue() -> TypedValue {
		.unsignedInt(self)
	}
}

extension Double: TypedValuable {
	public func toTypedValue() -> TypedValue {
		.double(self)
	}
}

extension HashMap: TypedValuable {
	public func toTypedValue() -> TypedValue {
		.hashMap(self)
	}
}

public struct List: TypedValuable {
	public init(@KeyValueBuilder value: @escaping () -> [TypedValue]) {
		self.value = value
	}

	@KeyValueBuilder let value: () -> [TypedValue]

	public func toTypedValue() -> TypedValue {
		.array(value())
	}
}

public struct Map: TypedValuable {
	public init(@KeyValueBuilder value: @escaping () -> [TypedValue]) {
		self.value = value
	}

	@KeyValueBuilder let value: () -> [TypedValue]

	public func toTypedValue() -> TypedValue {
		var hashMap = HashMap()
		for k in value() {
			switch k {
			case let .hashMap(h):
				for (k, v) in h {
					hashMap[k] = v
				}
			default:
				continue
			}
		}
		return .hashMap(hashMap)
	}
}

public struct Key: TypedValuable {
	public init(_ key: String, @KeyValueBuilder value: @escaping () -> [TypedValue]) {
		self.key = key
		self.value = value
	}

	let key: String

	@KeyValueBuilder let value: () -> [TypedValue]

	public func toTypedValue() -> TypedValue {
		let v = value()

		if v.count == 1 {
			return .hashMap([
				key: v[0],
			])
		}

		return .hashMap([
			key: .array(v),
		])
	}
}

@resultBuilder
public enum KeyValueBuilder {
	public static func buildBlock() -> [TypedValuable] {
		[]
	}

	public static func buildBlock(_ components: TypedValuable...) -> [any TypedValuable] {
		components
	}

	#if compiler(>=5.7)
		public static func buildPartialBlock(_: TypedValuable...) -> [any TypedValuable] {
			fatalError()
		}
	#endif

	public static func buildFinalResult(_ component: [TypedValuable]) -> [TypedValue] {
		component.map { $0.toTypedValue() }
	}
}

public func makeTypedValue(@KeyValueBuilder _ content: () -> [TypedValue]) -> TypedValue {
	let v = content()
	return .array(v)
}

public func makeHashMap(@KeyValueBuilder _ content: () -> [TypedValue]) -> HashMap {
	let v = makeTypedValue(content)
	switch v {
	case let .array(array):
		guard let first = array.first else {
			fatalError()
		}
		switch first {
		case let .hashMap(hashMap):
			return hashMap
		default:
			fatalError()
		}
	default:
		fatalError()
	}
}
