// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataFactory",
    products: [
        .library(
			name: "DataFactory",
			targets: ["DataFactory"]
		),
    ],
    dependencies: [],
    targets: [
        .target(
			name: "DataFactory",
			dependencies: []
		),
    ]
)
