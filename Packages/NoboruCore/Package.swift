// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NoboruCore",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "NoboruCore",
            targets: ["NoboruCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/AdevintaSpain/SwiftAdditions.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "NoboruCore",
            dependencies: [
                .product(name: "Additions", package: "SwiftAdditions"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "NoboruCoreTests",
            dependencies: [
                "NoboruCore",
                .product(name: "Additions", package: "SwiftAdditions"),
            ]
        )
    ]
)
