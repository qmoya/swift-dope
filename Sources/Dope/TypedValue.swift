public enum TypedValue: Equatable, Hashable, Decodable {
	case string(String)
	case int(Int)
	case double(Double)
	case hashMap(HashMap)
	case array([TypedValue])

	public init(from decoder: Decoder) throws {
		if let container = try? decoder.singleValueContainer() {
			if let v = try? container.decode(String.self) {
				self = .string(v)
				return
			}
			if let v = try? container.decode(Int.self) {
				self = .int(v)
				return
			}
			if let v = try? container.decode(Double.self) {
				self = .double(v)
				return
			}
			if let v = try? container.decode(HashMap.self) {
				self = .hashMap(v)
				return
			}
			if let v = try? container.decode([TypedValue].self) {
				self = .array(v)
				return
			}
		}
		throw DecodingError
			.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unexpected data"))
	}
}
