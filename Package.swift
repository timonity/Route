// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Route",
    products: [
        .library(
            name: "Route",
            targets: ["Route"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Route",
            dependencies: [],
            path: "Source",
            exclude: [
                "Example",
                "Route.podspec",
                "LICENSE",
                "README.md"
            ]
        )
    ]
)
