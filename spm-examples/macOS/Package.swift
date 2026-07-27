// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VersionDemo",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(path: "../.."),
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
