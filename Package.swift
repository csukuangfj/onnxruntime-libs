// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "onnxruntime-libs",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15),
        .visionOS(.v1),
    ],
    products: [
        // High-level Swift wrapper (works on all platforms)
        .library(
            name: "OnnxRuntime",
            targets: ["OnnxRuntime"]
        ),
        // Per-platform binary targets for direct use
        .library(name: "onnxruntime-macos", targets: ["onnxruntime-macos"]),
        .library(name: "onnxruntime-ios", targets: ["onnxruntime-ios"]),
        .library(name: "onnxruntime-visionos", targets: ["onnxruntime-visionos"]),
    ],
    targets: [
        // Binary targets for pre-built xcframeworks
        .binaryTarget(
            name: "onnxruntime-macos",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-macos-static-xcframework-1.27.1.xcframework.zip",
            checksum: "a2a3c65e5b94119e594994f2e7f4ce7eebb257b93c82d9539e190b7c6ab0d005"
        ),
        .binaryTarget(
            name: "onnxruntime-ios",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-ios-static-xcframework-1.27.1.xcframework.zip",
            checksum: "985deaff345c7bcfbe4979b2daeec09d7a745b1e9cb73f37f4077364eb578e62"
        ),
        .binaryTarget(
            name: "onnxruntime-visionos",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-visionos-static-xcframework-1.27.1.xcframework.zip",
            checksum: "206cdc2f23a1679aa3b3a91a74a866fad56a7ea50709fe5d4a67fb9b868c6234"
        ),

        // Swift wrapper that re-exports the C API
        .target(
            name: "OnnxRuntime",
            dependencies: [
                "onnxruntime-macos",
                "onnxruntime-ios",
                "onnxruntime-visionos",
            ],
            linkerSettings: [
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreML"),
            ]
        ),

        // Demo executable
        .executableTarget(
            name: "VersionDemo",
            dependencies: ["OnnxRuntime"],
            path: "Examples/VersionDemo"
        ),
    ]
)
