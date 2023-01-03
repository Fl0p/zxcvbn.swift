// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Zxcvbn",
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
                .copy("Resources/")
            ]
        ),
        .testTarget(
            name: "ZxcvbnTests",
            dependencies: ["Zxcvbn"]),
    ]
)
