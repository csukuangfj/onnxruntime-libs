// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VersionDemo",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/csukuangfj/onnxruntime-libs", branch: "master"),
    ],
    targets: [
        .executableTarget(
            name: "VersionDemo",
            dependencies: [
                .product(name: "OnnxRuntimeKit", package: "onnxruntime-libs"),
            ]
        ),
    ]
)
