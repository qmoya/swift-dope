import XCTest
import Dope
@testable import Spec

final class DopeTests: XCTestCase {
	func testItDoesNotThrowWhenValid() throws {
		let item: HashMap = [
			"my_number": .int(123),
			"my_string": .string("abc")
		]
		
		let schema: HashMap = [
			"$schema": .string("http://json-schema.org/draft-06/schema#"),
			"$ref": .string("#/definitions/Example"),
			"definitions": .hashMap([
				"Example": .hashMap([
					"type": .string("object"),
					"additionalProperties": .bool(false),
					"properties": .hashMap([
						"my_number": .hashMap([
							"type": .string("integer")
						]),
						"my_string": .hashMap([
							"type": .string("string")

						])
					]),
					"required": .array([
						.string("my_number"),
						.string("my_string")
					]),
					"title": .string("Example")
				])
			])
		]
		
		XCTAssertNoThrow(try Spec.validate(schema, .hashMap(item)))
	}
	
	func testItThrowsWhenInvalid() throws {
		let item: HashMap = [
			"my_number": .int(123),
		]
		
		let schema: HashMap = [
			"$schema": .string("http://json-schema.org/draft-06/schema#"),
			"$ref": .string("#/definitions/Example"),
			"definitions": .hashMap([
				"Example": .hashMap([
					"type": .string("object"),
					"additionalProperties": .bool(false),
					"properties": .hashMap([
						"my_number": .hashMap([
							"type": .string("integer")
						]),
						"my_string": .hashMap([
							"type": .string("string")

						])
					]),
					"required": .array([
						.string("my_number"),
						.string("my_string")
					]),
					"title": .string("Example")
				])
			])
		]
		
		XCTAssertThrowsError(try Spec.validate(schema, .hashMap(item)))
	}
}
