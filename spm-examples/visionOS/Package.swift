// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VersionDemo",
    platforms: [.visionOS(.v1)],
    dependencies: [
        .package(url: "https://github.com/csukuangfj/onnxruntime-libs", branch: "fix-macos"),
    ],
    targets: [
        .executableTarget(
            name: "VersionDemo",
            dependencies: [
                .product(name: "OnnxRuntime", package: "onnxruntime-libs"),
            ]
        ),
    ]
)
