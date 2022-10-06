import XCTest
@testable import DopeHTTP

final class TestingProtocol: URLProtocol {
	override class func canInit(with _: URLRequest) -> Bool {
		true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		request
	}

	override func startLoading() {
		let string = #"{"number": 123, "string": "abc"}"#
		let data = string.data(using: .utf8)!
		let response = HTTPURLResponse(
			url: request.url!,
			statusCode: 200,
			httpVersion: nil,
			headerFields: nil
		)!

		client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
		client?.urlProtocol(self, didLoad: data)
		client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() {}
}

final class DopeHTTPTests: XCTestCase {
	override func setUpWithError() throws {
		URLProtocol.registerClass(TestingProtocol.self)
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testExample() async throws {
		let client = makeClient(.shared, [:])
		let response = try await client([:])

		XCTAssertEqual(response[hashMap: "body", default: [:]][int: "number"], 123)
	}
}
