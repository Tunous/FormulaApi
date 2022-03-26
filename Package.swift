// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FormulaApi",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "FormulaApi",
            targets: ["FormulaApi"]
        ),
    ],
    dependencies: [
        .package(name: "Mocker", url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "2.5.5")),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "FormulaApi",
            dependencies: []
        ),
        .testTarget(
            name: "FormulaApiTests",
            dependencies: ["FormulaApi", "Mocker"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
