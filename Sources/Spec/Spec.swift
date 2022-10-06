//
//  File.swift
//  
//
//  Created by Quico Moya on 05.10.22.
//

import Foundation
import JSONSchema
import Dope

typealias Path = String
typealias Specification = HashMap

typealias UnvalidatedItem = TypedValue
typealias ValidatedItem = TypedValue

typealias SerializeSpec = (JSONEncoder, Specification) throws -> [String: Any]
typealias SerializeUnvalidatedItem = (JSONEncoder, UnvalidatedItem) throws -> [String: Any]

typealias Validate = (@escaping SerializeSpec, @escaping SerializeUnvalidatedItem) -> (Specification, UnvalidatedItem) throws -> ValidatedItem

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

let makeValidate: Validate = { serializeSpec, serializeUnvalidatedItem in
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

let validate = makeValidate(serializeSpec, serializeUnvalidatedItem)
