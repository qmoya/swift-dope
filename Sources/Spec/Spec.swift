import Dope
import Foundation
import JSONSchema

// MARK: Data

// A JSON Schema Draft 4, 6, 7, 2019-09, 2020-12 specification.
public typealias Specification = HashMap

// A filename.
public typealias FileBaseName = String

// An unvalidated item.
public typealias UnvalidatedItem = TypedValue

// A validated item.
public typealias ValidatedItem = TypedValue

// MARK: Functions

// Serialize a spec into a [String: Any] dictionary.
typealias SerializeSpec = (JSONEncoder, Specification) throws -> [String: Any]

// Serialize an unvalidated item into a [String: Any] dictionary.
typealias SerializeUnvalidatedItem = (JSONEncoder, UnvalidatedItem) throws -> Any

// Validate an unvalidated item using a specification.
public typealias AssertWithSpecification = (Specification, UnvalidatedItem) throws -> ValidatedItem

// Validate an unvalidated item using a file.
public typealias AssertWithFile = (FileBaseName,  UnvalidatedItem) throws -> ValidatedItem

// Make a validate function.
typealias MakeAssertWithSpecification = (@escaping SerializeSpec, @escaping SerializeUnvalidatedItem)
	-> AssertWithSpecification

public typealias MakeAssertWithFile = (Bundle) -> AssertWithFile

// MARK: Implementation

let serializeSpec: SerializeSpec = { encoder, specification in
	let specJSON = try encoder.encode(specification)
	let serialized = try JSONSerialization.jsonObject(with: specJSON) as! [String: Any]
	return serialized
}

let serializeUnvalidatedItem: SerializeUnvalidatedItem = { encoder, item in
	let itemJSON = try encoder.encode(item)
	return try JSONSerialization.jsonObject(with: itemJSON)
}

let makeAssertWithSpecification: MakeAssertWithSpecification = { serializeSpec, serializeUnvalidatedItem in
	{ specification, item in
		let encoder = JSONEncoder()

		let serializedItem = try serializeUnvalidatedItem(encoder, item)
		let serializedSpec = try serializeSpec(encoder, specification)
		
		let validationResult = try JSONSchema.validate(serializedItem, schema: serializedSpec)

		switch validationResult {
		case .valid:
			return item
		case let .invalid(errors):
			let errorsJSON = try encoder.encode(errors)
			let decoder = JSONDecoder()
			let errors = try decoder.decode([TypedValue].self, from: errorsJSON)
			throw errors
		}
	}
}

public let makeAssertWithFile: MakeAssertWithFile = { bundle in
	{ baseName, item in
		let file = bundle.path(forResource: baseName, ofType: "json")!
		let data = try NSData(contentsOfFile: file) as Data
		let encoder = JSONEncoder()
		let serializedSpec = try JSONSerialization.jsonObject(with: data) as! [String: Any]

		let serializedItem = try serializeUnvalidatedItem(encoder, item)
		let validationResult = try JSONSchema.validate(serializedItem, schema: serializedSpec)

		switch validationResult {
		case .valid:
			return item
		case let .invalid(errors):
			let errorsJSON = try encoder.encode(errors)
			let decoder = JSONDecoder()
			let errors = try decoder.decode([TypedValue].self, from: errorsJSON)
			throw errors
		}
	}
}

public let assertWithSpecification: AssertWithSpecification = makeAssertWithSpecification(serializeSpec, serializeUnvalidatedItem)
