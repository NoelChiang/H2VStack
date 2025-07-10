// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "H2VStack",
    platforms: [
        .iOS(.v16)
    ]
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "H2VStack",
            targets: ["H2VStack"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "H2VStack"),
        .testTarget(
            name: "H2VStackTests",
            dependencies: ["H2VStack"]
        ),
    ]
)
