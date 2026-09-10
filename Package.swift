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
            checksum: "39f816cac19cb76e0f504b2d7c91fec3e889c25bf5b9b474297b19eb0bd69a31"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-ios-static-xcframework-1.28.2.xcframework.zip",
            checksum: "306b740d513a1af5c9f1c3a7d2ca98d8bf5491a558a45ef2b14cbed4fde64059"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOS",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-visionos-static-xcframework-1.28.2.xcframework.zip",
            checksum: "f255197cb35505715bc91d7f3ff6c4c77cc0f1eb511bb743f9661b16feb50666"
        ),

        // --- Shared binary targets (one per platform) ---
        .binaryTarget(
            name: "OnnxruntimeMacOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-macos-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "4703c0e937d2c6e6421086eae6b23026e37acbd848ac757bc190b6ad67cffd53"
        ),
        .binaryTarget(
            name: "OnnxruntimeIOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-ios-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "a2c49aecf40f20d1cb271bfba4f87671637c9fa4de69f11fc75671ec2d8f7c5d"
        ),
        .binaryTarget(
            name: "OnnxruntimeVisionOSShared",
            url: "https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.28.2/onnxruntime-visionos-shared-xcframework-1.28.2.xcframework.zip",
            checksum: "f8195d79f6d541cdbe766f4691869ba4560d92a7dc9462b7d730c138650c4f6b"
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
