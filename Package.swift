// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "Services",
            dependencies: []),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["Services"]),
    ]
)
