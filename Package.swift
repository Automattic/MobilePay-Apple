// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MobilePayKit",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "MobilePayKit",
            targets: ["MobilePayKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", .upToNextMajor(from: "9.1.0")),
    ],
    targets: [
        .target(
            name: "MobilePayKit",
            path: "Source"
        ),
        .testTarget(
            name: "MobilePayKitTests",
            dependencies: [
                .target(name: "MobilePayKit"),
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
            ],
            path: "Tests",
            resources: [
                .copy("iap-orders-success.json"),
                .copy("iap-products-success.json"),

            ]
        ),
    ]
)
