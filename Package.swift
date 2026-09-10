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
        .library(name: "OnnxRuntimeKit", targets: ["OnnxRuntimeKit"]),
        // Shared/dynamic xcframework
        .library(name: "OnnxRuntimeSharedKit", targets: ["OnnxRuntimeSharedKit"]),
        // Per-platform binary targets for direct use
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
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-macos-static-xcframework-1.28.2.xcframework.zip",
            checksum: "29f2382e7d3a464d9a6d00d25fb072b693d1ee23960bb2dbec2d98be5cf23b0c"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-ios-static-xcframework-1.28.2.xcframework.zip",
            checksum: "755226bc34b97c96ca3f6f3296c04309e1d1d5324814bc3339167fbead2e0677"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-visionos-static-xcframework-1.28.2.xcframework.zip",
            checksum: "b0b0b2d1ab2244b6cbf3bfc5ba19d0aaf5d0982841c2f2b86b81f4ab6ba95b30"
        ),

        // --- Shared binary targets (one per platform) ---
        .binaryTarget(
            name: "OnnxruntimeMacOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-macos-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "7b0758f98e69f0be057094a890e9b3f51683ddf7519f651fdf54a2bc03e42b66"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-ios-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "e6d51b07df6fb2d657d4d08b144e46f2a091117128861561db4cbc340bd627a3"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-visionos-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "918bb7d37300a38b80cbc0e293686938717a4dd26230b8b83b00be4d18097e8f"
        ),

        // --- Static wrapper (default) ---
        .target(
            name: "OnnxRuntimeKit",
            dependencies: [
                .target(name: "OnnxruntimeMacOS", condition: .when(platforms: [.macOS])),
                .target(name: "OnnxruntimeIOS", condition: .when(platforms: [.iOS])),
                .target(name: "OnnxruntimeVisionOS", condition: .when(platforms: [.visionOS])),
            ],
            linkerSettings: [
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreML"),
                .linkedLibrary("c++"),
            ]
        ),

        // --- Shared wrapper ---
        .target(
            name: "OnnxRuntimeSharedKit",
            dependencies: [
                .target(name: "OnnxruntimeMacOSShared", condition: .when(platforms: [.macOS])),
                .target(name: "OnnxruntimeIOSShared", condition: .when(platforms: [.iOS])),
                .target(name: "OnnxruntimeVisionOSShared", condition: .when(platforms: [.visionOS])),
            ],
            path: "Sources/OnnxRuntimeSharedKit",
            linkerSettings: [
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreML"),
                .linkedLibrary("c++"),
            ]
        ),

        // Demo
        .executableTarget(
            name: "VersionDemo",
            dependencies: ["OnnxRuntimeKit"],
            path: "Examples/VersionDemo"
        ),
    ]
)
