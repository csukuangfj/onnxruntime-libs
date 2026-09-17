// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "onnxruntime-libs",
    platforms: [.macOS(.v10_15)],
    products: [.library(name: "OnnxRuntimeKit", targets: ["OnnxRuntimeKit"])],
    targets: [
        .binaryTarget(name: "OnnxruntimeMacOS", path: "__ZIP_PATH__"),
        .target(name: "OnnxRuntimeKit", dependencies: [.target(name: "OnnxruntimeMacOS")],
            linkerSettings: [.linkedFramework("CoreFoundation"), .linkedFramework("Foundation"), .linkedFramework("CoreML"), .linkedLibrary("c++")]),
        .executableTarget(name: "VersionDemo", dependencies: ["OnnxRuntimeKit"], path: "Examples/VersionDemo"),
    ]
)
