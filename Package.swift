// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Dope",
	platforms: [.iOS(.v15), .macOS(.v12)],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "Dope",
			targets: ["Dope"]
		),
		.library(
			name: "DopeHTTP",
			targets: ["DopeHTTP"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/kylef/JSONSchema.swift.git", from: "0.6.0")
	],
	targets: [
		.target(
			name: "Dope",
			dependencies: []
		),
		
		.testTarget(
			name: "DopeTests",
			dependencies: ["Dope"]
		),
		
		.target(
			name: "Spec",
			dependencies: [
				"Dope",
				.product(name: "JSONSchema", package: "JSONSchema.swift")
			]
		),

		.testTarget(
			name: "SpecTests",
			dependencies: ["Spec"]
		),

		.target(
			name: "DopeHTTP",
			dependencies: ["Dope"]
		),
		
		.testTarget(
			name: "DopeHTTPTests",
			dependencies: ["DopeHTTP"]
		),
	]
)
