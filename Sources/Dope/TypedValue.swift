public enum TypedValue: Equatable, Hashable, Codable {
	case bool(Bool)
	case string(String)
	case int(Int)
	case unsignedInt(UInt)
	case double(Double)
	case hashMap(HashMap)
	case array([TypedValue])

	public init(from decoder: Decoder) throws {
		if let container = try? decoder.singleValueContainer() {
			if let v = try? container.decode(String.self) {
				self = .string(v)
			} else if let v = try? container.decode(Int.self) {
				self = .int(v)
			} else if let v = try? container.decode(Bool.self) {
				self = .bool(v)
			} else if let v = try? container.decode(UInt.self) {
				self = .unsignedInt(v)
			} else if let v = try? container.decode(Double.self) {
				self = .double(v)
			} else if let v = try? container.decode(HashMap.self) {
				self = .hashMap(v)
			} else if let v = try? container.decode([TypedValue].self) {
				self = .array(v)
			} else {
				throw DecodingError.dataCorruptedError(in: container, debugDescription: "unexpected data")
			}
		} else {
			throw DecodingError
				.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unexpected data"))
		}
	}

	public func encode(to encoder: Encoder) throws {
		var singleValueContainer = encoder.singleValueContainer()
		switch self {
		case let .string(v):
			try singleValueContainer.encode(v)
		case let .int(v):
			try singleValueContainer.encode(v)
		case let .double(v):
			try singleValueContainer.encode(v)
		case let .hashMap(v):
			try singleValueContainer.encode(v)
		case let .array(v):
			try singleValueContainer.encode(v)
		case let .unsignedInt(v):
			try singleValueContainer.encode(v)
		case let .bool(v):
			try singleValueContainer.encode(v)
		}
	}
}
