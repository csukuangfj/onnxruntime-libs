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
            checksum: "cb0b0bec912c77229517c463e28a3fac9674c521f9599919efff1ef2b42f3da0"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-ios-static-xcframework-1.28.2.xcframework.zip",
            checksum: "2c2299acbb461d26d4bac4bc85985d40e7c7177ed6072703ae0846d88b0b4599"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-visionos-static-xcframework-1.28.2.xcframework.zip",
            checksum: "0961770125a898ea5ee88b288ba8e63dc0b4dac069aeb7e2405e218b66dae1d7"
        ),

        // --- Shared binary targets (one per platform) ---
        .binaryTarget(
            name: "OnnxruntimeMacOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-macos-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "99a47f4d3e24a2f6e9ab1231692e96093297dd5d8e7f47c86ed4efc9554438d7"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-ios-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "d955b44322de53cc0be60e4939c89e46c2ba9dc0e9eef7f25ec8c73427ac6546"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-visionos-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "f5445a78438b0ee82eedd1beb2ce82f4ba77bcef10ffa38f5fed6b8b154e3def"
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
