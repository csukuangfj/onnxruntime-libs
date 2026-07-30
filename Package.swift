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
        // Static xcframework (default)
        .library(name: "OnnxRuntime", targets: ["OnnxRuntime"]),
        // Shared/dynamic xcframework
        .library(name: "OnnxRuntime-Shared", targets: ["OnnxRuntimeShared"]),
        // Per-platform binary targets for direct use (bypasses wrapper)
        .library(name: "onnxruntime-macos", targets: ["OnnxruntimeMacOS"]),
        .library(name: "onnxruntime-ios", targets: ["OnnxruntimeIOS"]),
        .library(name: "onnxruntime-visionos", targets: ["OnnxruntimeVisionOS"]),
        .library(name: "onnxruntime-macos-shared", targets: ["OnnxruntimeMacOSShared"]),
        .library(name: "onnxruntime-ios-shared", targets: ["OnnxruntimeIOSShared"]),
        .library(name: "onnxruntime-visionos-shared", targets: ["OnnxruntimeVisionOSShared"]),
    ],
    targets: [
        // --- Static binary targets (one per platform) ---
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

        // --- Shared binary targets (one per platform) ---
        .binaryTarget(
            name: "OnnxruntimeMacOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-macos-shared-xcframework-1.27.1.xcframework.zip",
            checksum: "9d1d49b7c5ba7d5ccff048aff3f0c40431f8232b67259df9ab7f85d76e57cb75"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-ios-shared-xcframework-1.27.1.xcframework.zip",
            checksum: "0f771394c109d2f1fd6b28bfdf197bda253e67be11a1f7b2b60559b200a84671"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.27.1/onnxruntime-visionos-shared-xcframework-1.27.1.xcframework.zip",
            checksum: "8cf35459c30f05f8e764035fc74e76d7716d06bf405847b1e7acf8278424a2d1"
        ),

        // --- Static wrapper (default) ---
        .target(
            name: "OnnxRuntime",
            dependencies: [
                .target(name: "OnnxruntimeMacOS", condition: .when(platforms: [.macOS])),
                .target(name: "OnnxruntimeIOS", condition: .when(platforms: [.iOS])),
                .target(name: "OnnxruntimeVisionOS", condition: .when(platforms: [.visionOS])),
            ],
            linkerSettings: [
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreML"),
            ]
        ),

        // --- Shared wrapper ---
        .target(
            name: "OnnxRuntimeShared",
            dependencies: [
                .target(name: "OnnxruntimeMacOSShared", condition: .when(platforms: [.macOS])),
                .target(name: "OnnxruntimeIOSShared", condition: .when(platforms: [.iOS])),
                .target(name: "OnnxruntimeVisionOSShared", condition: .when(platforms: [.visionOS])),
            ],
            path: "Sources/OnnxRuntimeShared",
            linkerSettings: [
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreML"),
            ]
        ),

        // Demo
        .executableTarget(
            name: "VersionDemo",
            dependencies: ["OnnxRuntime"],
            path: "Examples/VersionDemo"
        ),
    ]
)
