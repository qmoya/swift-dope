//
//  File.swift
//  
//
//  Created by Quico Moya on 14.10.22.
//

import Foundation

protocol TypedValuable {
	func makeTypeValue() -> [TypedValue]
}

struct UnKeyedValue: TypedValuable {
	let element: TypedValue
	
	func makeTypeValue() -> [TypedValue] {
		[element]
	}
}

struct TypedArray: TypedValuable {
	let elements: [TypedValue]
	
	func makeTypeValue() -> [TypedValue] {
		elements
	}
}

//extension TypedArray {
//	init(@TypedValuableBuilder _ builder: () -> [any TypedValuable]) {
//		elements =
//	}
//}

struct KeyedValue: TypedValuable {
	let key: String
	@TypedValuableBuilder var value: () -> [any TypedValuable]
	
	func makeTypeValue() -> [TypedValue] {
		value().map { $0.makeTypeValue() }
	}
}

@resultBuilder
struct TypedValuableBuilder {
	static func buildBlock(_ component: any TypedValuable) -> any TypedValuable {
		component
	}

	static func buildBlock(_ components: any TypedValuable...) -> any TypedValuable {
		TypedArray(elements: components.map { $0.makeTypeValue() })
	}
	
	static func buildEither(first component: TypedValuable) -> any TypedValuable {
		return UnKeyedValue(element: component.makeTypeValue())
	}
	
	static func buildEither(second component: TypedValuable) -> any TypedValuable {
		return UnKeyedValue(element: component.makeTypeValue())
	}
	
//	static func buildBlock(_ a: TypedValuable, _ b: TypedValuable) -> any TypedValuable {
//		switch (a.makeTypeValue(), b.makeTypeValue()) {
//		case let (.hashMap(ha), .hashMap(hb)):
//			return UnKeyedValue(element: .hashMap(ha.merging(hb, uniquingKeysWith: { l, r in r })))
//		default:
//			fatalError()
//		}
//	}
	
//	static func buildPartialBlock(first content: KeyedValue) -> any TypedValuable {
//		switch content.value {
//		case .hashMap:
//			return content
//		default:
//			fatalError()
//		}
//	}
//
//	static func buildPartialBlock(accumulated: KeyedValue, next: KeyedValue) -> TypedValuable {
//		switch (accumulated, next) {
//		case accumulated.value :
//			ac[n.key] = n.value
//			return hashMap
//		default:
//			fatalError()
//		}
//	}
}

func makeTypedValue(@TypedValuableBuilder _ builder: () -> TypedValuable) -> TypedValue {
	let value = builder().makeTypeValue()
	return value
}
