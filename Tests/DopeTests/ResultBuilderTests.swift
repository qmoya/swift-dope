import XCTest
@testable import Dope

final class ResultBuilderTests: XCTestCase {
	func testArray() throws {
        let example: TypedValue = makeTypedValue {
            UnKeyedValue(element: TypedValue.string("hello"))
            UnKeyedValue(element: TypedValue.string("goodbye"))
        }

        XCTAssertEqual(example, TypedValue.array([TypedValue.string("hello"), TypedValue.string("goodbye")]))
	}

    func testSingle() throws {
        let example: TypedValue = makeTypedValue {
            UnKeyedValue(element: TypedValue.string("hello"))
        }

        XCTAssertEqual(example, TypedValue.string("hello"))
    }

    func testKeyed() throws {
        let example: TypedValue = makeTypedValue {
			KeyedValue(key: "hello") {
				UnKeyedValue(element: .string("world"))
			}
        }

        XCTAssertEqual(example, TypedValue.hashMap(["hello": TypedValue.string("world")]))
    }

    func testKeyedArray() throws {
        let example: TypedValue = makeTypedValue {
            KeyedValue(key: "hello", value: TypedValue.string("world"))
            KeyedValue(key: "goodbye", value: TypedValue.string("world"))
        }

        XCTAssertEqual(example, TypedValue.hashMap([
            "hello": TypedValue.string("world"), 
            "goodbye": TypedValue.string("world")
        ]))
    }

    func testKeyedArrayMixed() throws {
        let example: TypedValue = makeTypedValue {
            KeyedValue(key: "sections") {
                UnKeyedValue(element: TypedValue.string("hello"))
                UnKeyedValue(element: TypedValue.string("goodbye"))
            }
        }
		
		XCTAssertEqual(example, TypedValue.hashMap([
			"sections": TypedValue.array([
					TypedValue.string("hello"),
					TypedValue.string("goodbye")
				]
			)
		]))
    }
	
	func testKeyedSingleMixed() throws {
		let example: TypedValue = makeTypedValue {
			KeyedValue(key: "sections") {
				UnKeyedValue(element: TypedValue.string("hello"))
			}
		}
		
		XCTAssertEqual(example, TypedValue.hashMap([
			"sections": TypedValue.string("hello")
		]))
	}
}
