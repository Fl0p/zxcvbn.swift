// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Zxcvbn",
    platforms: [.iOS(.v15), .watchOS(.v7)],
    products: [
        .library(
            name: "Zxcvbn",
            targets: ["Zxcvbn"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Zxcvbn",
            dependencies: [],
            resources: [
            ]
        ),
        .testTarget(
            name: "ZxcvbnTests",
            dependencies: ["Zxcvbn"]),
    ]
)
