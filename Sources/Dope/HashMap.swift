import Foundation

public struct HashMap: Equatable, Hashable, Decodable, ExpressibleByDictionaryLiteral {
	public typealias Key = String
	public typealias Value = TypedValue

	public init(dictionaryLiteral elements: (String, TypedValue)...) {
		storage = elements.reduce([:]) { partialResult, element in
			var copy = partialResult
			copy[element.0] = element.1
			return copy
		}
	}

	public init(_ dictionary: [String: TypedValue]) {
		storage = dictionary
	}

	private var storage: [String: TypedValue] = [:]

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		if let dictionary = try? container.decode([String: TypedValue].self) {
			storage = dictionary
		} else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "AnyDecodable value cannot be decoded"
			)
		}
	}
}

extension HashMap: Error {}

public extension HashMap {
	subscript(string key: String) -> String? {
		get {
			switch storage[key] {
			case let .string(string):
				return string
			default:
				return nil
			}
		}
		set {
			guard let v = newValue else {
				storage.removeValue(forKey: key)
				return
			}
			storage[key] = .string(v)
		}
	}

	subscript(string key: String, default fallback: String) -> String {
		self[string: key] ?? fallback
	}

	subscript(int key: String) -> Int? {
		switch storage[key] {
		case let .int(int):
			return int
		default:
			return nil
		}
	}

	subscript(int key: String, default fallback: Int) -> Int {
		self[int: key] ?? fallback
	}

	subscript(double key: String) -> Double? {
		switch storage[key] {
		case let .double(double):
			return double
		default:
			return nil
		}
	}

	subscript(int key: String, default fallback: Double) -> Double {
		self[double: key] ?? fallback
	}

	subscript(hashMap key: String) -> HashMap? {
		switch storage[key] {
		case let .hashMap(hashMap):
			return hashMap
		default:
			return nil
		}
	}

	subscript(hashMap key: String, default fallback: HashMap) -> HashMap {
		self[hashMap: key] ?? fallback
	}

	subscript(array key: String) -> [TypedValue]? {
		get {
			switch storage[key] {
			case let .array(array):
				return array
			default:
				return nil
			}
		}
		set {
			guard let v = newValue else {
				storage.removeValue(forKey: key)
				return
			}
			storage[key] = .array(v)
		}
	}

	subscript(array key: String, default fallback: [TypedValue]) -> [TypedValue] {
		self[array: key] ?? fallback
	}
}
