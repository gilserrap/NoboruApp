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
    dependencies: [],
    targets: [
        .target(
            name: "NoboruCore",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "NoboruCoreTests",
            dependencies: ["NoboruCore"]
        )
    ]
)
