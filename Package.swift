// swift-tools-version:5.3
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
    targets: [
        .target(
            name: "MobilePayKit",
            path: "Source"),
        .testTarget(
            name: "MobilePayKitTests",
            dependencies: ["MobilePayKit"],
            path: "Tests"),
    ]
)
