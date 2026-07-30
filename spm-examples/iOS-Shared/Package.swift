// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VersionDemo",
    platforms: [.iOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/csukuangfj/onnxruntime-libs", branch: "fix-macos"),
    ],
    targets: [
        .executableTarget(
            name: "VersionDemo",
            dependencies: [
                .product(name: "OnnxRuntime-Shared", package: "onnxruntime-libs"),
            ]
        ),
    ]
)
