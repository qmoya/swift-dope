import Dope
import Foundation
import JSONSchema

// MARK: Data

// A JSON Schema Draft 4, 6, 7, 2019-09, 2020-12 specification.
public typealias Specification = HashMap

// An unvalidated item.
public typealias UnvalidatedItem = TypedValue

// A validated item.
public typealias ValidatedItem = TypedValue

// MARK: Functions

// Serialize a spec into a [String: Any] dictionary.
typealias SerializeSpec = (JSONEncoder, Specification) throws -> [String: Any]

// Serialize an unvalidated item into a [String: Any] dictionary.
typealias SerializeUnvalidatedItem = (JSONEncoder, UnvalidatedItem) throws -> [String: Any]

// Validate an unvalidated item using a specification.
public typealias Validate = (Specification, UnvalidatedItem) throws -> ValidatedItem

// Make a validate function.
typealias MakeValidate = (@escaping SerializeSpec, @escaping SerializeUnvalidatedItem)
	-> Validate

// MARK: Implementation

let serializeSpec: SerializeSpec = { encoder, specification in
	let specJSON = try encoder.encode(specification)
	let serialized = try JSONSerialization.jsonObject(with: specJSON) as! [String: Any]
	return serialized
}

let serializeUnvalidatedItem: SerializeUnvalidatedItem = { encoder, item in
	let itemJSON = try encoder.encode(item)
	let serialized = try JSONSerialization.jsonObject(with: itemJSON) as! [String: Any]
	return serialized
}

let makeValidate: MakeValidate = { serializeSpec, serializeUnvalidatedItem in
	{ specification, item in
		let encoder = JSONEncoder()

		let validationResult = try JSONSchema.validate(
			serializeUnvalidatedItem(encoder, item),
			schema: serializeSpec(encoder, specification)
		)

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

public let validate: Validate = makeValidate(serializeSpec, serializeUnvalidatedItem)
