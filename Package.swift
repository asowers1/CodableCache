import PackageDescription

let package = Package(
    name: "CodableCache",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "CodableCache",
            targets: ["CodableCache"]),
    ],
    targets: [
        .target(
            name: "CodableCache",
            dependencies: []
        ),
    ]
)
