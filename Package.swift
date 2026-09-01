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
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.1/onnxruntime-macos-static-xcframework-1.28.1.xcframework.zip",
            checksum: "38c9a1e8bcf2497ff5eb721195743e4b4367ade3cd1eb9869c0cfd1bd367c36b"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.1/onnxruntime-ios-static-xcframework-1.28.1.xcframework.zip",
            checksum: "992d8a0cc6014cccc3a7815c36bbff5e5a06833ea2c4d47dd43ef071f639cf9d"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.1/onnxruntime-visionos-static-xcframework-1.28.1.xcframework.zip",
            checksum: "f0579ff83ee1da776e0010026e8fdfebabed8fbeab59ddc176a9336113d44c1e"
        ),

        // --- Shared binary targets (one per platform) ---
        .binaryTarget(
            name: "OnnxruntimeMacOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.1/onnxruntime-macos-shared-xcframework-1.28.1.xcframework.zip",
            checksum: "06fa9d311802698f018ea2ede59ae65f9ce4ce9b38eb1b20cfac23f245e6609d"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.1/onnxruntime-ios-shared-xcframework-1.28.1.xcframework.zip",
            checksum: "3176d6748a7618038e6fbf47b3a4fdf2bfab714b0f678559d8663db648825017"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.1/onnxruntime-visionos-shared-xcframework-1.28.1.xcframework.zip",
            checksum: "e987cf2301be770bd30b0ac8e0a6cabb45c8215817de954e074e87171ffb3068"
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
