import XCTest
@testable import Dope

final class DopeTests: XCTestCase {
	func testEncoding() throws {
		let hashMap: HashMap = [
			"my_number": .int(123),
			"my_string": .string("abc")
		]
		
		let encoder = JSONEncoder()
		encoder.outputFormatting = .sortedKeys
		
		let data = try encoder.encode(hashMap)
		XCTAssertEqual(data, #"{"my_number":123,"my_string":"abc"}"#.data(using: .utf8))
	}
}
