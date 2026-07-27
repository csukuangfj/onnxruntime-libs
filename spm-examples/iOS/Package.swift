// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VersionDemo",
    platforms: [.iOS(.v15)],
    dependencies: [
        .package(path: "../.."),
    ],
    targets: [
        .executableTarget(
            name: "VersionDemo",
            dependencies: [
                .product(name: "onnxruntime-ios", package: "onnxruntime-libs"),
            ]
        ),
    ]
)
