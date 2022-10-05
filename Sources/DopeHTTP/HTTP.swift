import Dope
import Foundation

typealias Configuration = HashMap
typealias Request = HashMap
typealias Response = HashMap
typealias Client = (Request) async throws -> Response
typealias MakeClient = (URLSession, Configuration) -> Client

let makeClient: MakeClient = { urlSession, _ in
	{ request in
		let urlString = request[string: "url", default: "about:blank"]
		guard let url = URL(string: urlString) else {
			return ["error": .string("invalid url: \(urlString)")]
		}

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request[string: "method", default: "GET"]

		let (data, response) = try await urlSession.data(for: urlRequest)
		guard let httpResponse = response as? HTTPURLResponse else {
			throw HashMap(["description": .string("unexpected response")])
		}

		let decoder = JSONDecoder()
		let body = try decoder.decode(HashMap.self, from: data)

		return [
			"status_code": .int(httpResponse.statusCode),
			"body": .hashMap(body),
		]
	}
}
