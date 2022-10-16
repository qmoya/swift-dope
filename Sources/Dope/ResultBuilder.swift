import Foundation

protocol TypedValuable {
	func toTypedValue() -> TypedValue
}

extension String: TypedValuable {
	func toTypedValue() -> TypedValue {
		.string(self)
	}
}

extension Int: TypedValuable {
	func toTypedValue() -> TypedValue {
		.int(self)
	}
}

extension UInt: TypedValuable {
	func toTypedValue() -> TypedValue {
		.unsignedInt(self)
	}
}

extension Double: TypedValuable {
	func toTypedValue() -> TypedValue {
		.double(self)
	}
}

struct Group: TypedValuable {
	init(_ key: String, @KeyValueBuilder value: @escaping () -> [TypedValue]) {
		self.key = key
		self.value = value
	}
	
	let key: String
	
	@KeyValueBuilder let value: () -> [TypedValue]
	
	func toTypedValue() -> TypedValue {
		let v = value()
		
		if v.count == 1 {
			return .hashMap([
				key: v[0]
			])
		}
		
		return .hashMap([
			key: .array(v)
		])
	}
}

@resultBuilder
struct KeyValueBuilder {
	static func buildBlock() -> [TypedValuable] {
		[]
	}
	
	static func buildBlock(_ components: TypedValuable...) -> [any TypedValuable] {
		components
	}
	
	static func buildFinalResult(_ component: [TypedValuable]) -> [TypedValue] {
		component.map { $0.toTypedValue() }
	}
}

func makeTypedValue(@KeyValueBuilder _ content: () -> [TypedValue]) -> TypedValue {
	let v = content()
	
	if v.count == 1 {
		return v[0]
	}
	
	return .array(v)
}
