import XCTest
@testable import Dope

final class ResultBuilderTests: XCTestCase {
	func testArray() throws {
		let example: TypedValue = makeTypedValue {
			"hello"
			"goodbye"
		}

		XCTAssertEqual(example, .array([TypedValue.string("hello"), TypedValue.string("goodbye")]))
	}
	
	func testOneNested() throws {
		let example: TypedValue = makeTypedValue {
			Group("hello") {
				"goodbye"
			}
		}
		
		XCTAssertEqual(example, TypedValue.hashMap(["hello": .string("goodbye")]))
	}
	
	func testTwoNested() throws {
		let example: TypedValue = makeTypedValue {
			Group("hello") {
				"one"
				"two"
			}
		}
		
		XCTAssertEqual(example, TypedValue.hashMap(["hello": .array([.string("one"), .string("two")])]))
	}
}
