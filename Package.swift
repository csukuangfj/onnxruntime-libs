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
        .library(name: "onnxruntime-macos", targets: ["OnnxruntimeMacOS"]),
        .library(name: "onnxruntime-ios", targets: ["OnnxruntimeIOS"]),
        .library(name: "onnxruntime-visionos", targets: ["OnnxruntimeVisionOS"]),
    ],
    targets: [
        // Binary targets for pre-built xcframeworks
        .binaryTarget(
            name: "OnnxruntimeMacOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-macos-static-xcframework-1.27.1.xcframework.zip",
            checksum: "89769c25a63985e2ab7a12e72215c173c5078e49dc4a2273cb84b75e587d7b96"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-ios-static-xcframework-1.27.1.xcframework.zip",
            checksum: "985deaff345c7bcfbe4979b2daeec09d7a745b1e9cb73f37f4077364eb578e62"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-visionos-static-xcframework-1.27.1.xcframework.zip",
            checksum: "206cdc2f23a1679aa3b3a91a74a866fad56a7ea50709fe5d4a67fb9b868c6234"
        ),

        // Swift wrapper that re-exports the C API
        .target(
            name: "OnnxRuntime",
            dependencies: [
                "OnnxruntimeMacOS",
                "OnnxruntimeIOS",
                "OnnxruntimeVisionOS",
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
