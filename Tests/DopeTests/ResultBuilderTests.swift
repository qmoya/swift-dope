import XCTest
@testable import Dope

final class ResultBuilderTests: XCTestCase {
	func testSingleString() throws {
		let example: TypedValue = makeTypedValue {
			"hello"
		}

		XCTAssertEqual(example, .string("hello"))
	}

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

	func testTwoNestedAndMixed() throws {
		let example: TypedValue = makeTypedValue {
			Group("hello") {
				"one"
				2
			}
		}

		XCTAssertEqual(example, TypedValue.hashMap(["hello": .array([.string("one"), .int(2)])]))
	}

	func testTwoNestedAndMixedWithDouble() throws {
		let example: TypedValue = makeTypedValue {
			Group("hello") {
				1.0
				2
			}
		}

		XCTAssertEqual(example, TypedValue.hashMap(["hello": .array([.double(1), .int(2)])]))
	}
}
