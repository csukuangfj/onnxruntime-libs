// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VersionDemo",
    platforms: [.visionOS(.v1)],
    dependencies: [
        .package(url: "https://github.com/csukuangfj/onnxruntime-libs", branch: "release-v1.27.1"),
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
