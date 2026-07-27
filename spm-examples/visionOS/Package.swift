// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VersionDemo",
    platforms: [.visionOS(.v1)],
    dependencies: [
        .package(path: "../.."),
    ],
    targets: [
        .executableTarget(
            name: "VersionDemo",
            dependencies: [
                .product(name: "onnxruntime-visionos", package: "onnxruntime-libs"),
            ]
        ),
    ]
)
