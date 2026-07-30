# Plan: Refactor Package.swift with per-platform conditional dependencies

## Overview

Refactor `Package.swift` so each platform only downloads its own xcframework (not all three). Add shared xcframework support for all platforms. Follow the pattern from [SQLite.swift](https://github.com/stephencelis/SQLite.swift/blob/master/Package.swift).

## Changes

### 1. Refactor `Package.swift`

Use `.target(name:condition: .when(platforms:))` for conditional dependencies:

```swift
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
    ],
    targets: [
        // --- Static binary targets (one per platform) ---
        .binaryTarget(name: "OnnxruntimeMacOS", url: "...macos-static...", checksum: "89769c25..."),
        .binaryTarget(name: "OnnxruntimeIOS", url: "...ios-static...", checksum: "985deaff..."),
        .binaryTarget(name: "OnnxruntimeVisionOS", url: "...visionos-static...", checksum: "206cdc2f..."),

        // --- Shared binary targets (one per platform) ---
        .binaryTarget(name: "OnnxruntimeMacOSShared", url: "...macos-shared...", checksum: "9d1d49b7..."),
        .binaryTarget(name: "OnnxruntimeIOSShared", url: "...ios-shared...", checksum: "0f771394..."),
        .binaryTarget(name: "OnnxruntimeVisionOSShared", url: "...visionos-shared...", checksum: "8cf35459..."),

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
            path: "Sources/OnnxRuntime",
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
```

### 2. Update `spm-examples/`

Create shared examples:
- `spm-examples/macOS-Shared/` — macOS shared/dynamic
- `spm-examples/iOS-Shared/` — iOS shared
- `spm-examples/visionOS-Shared/` — visionOS shared

### 3. Update `.github/workflows/test-spm.yaml`

Add jobs for each shared example.

### 4. Files to change

| File | Action |
|------|--------|
| `Package.swift` | Rewrite with conditional deps + shared targets |
| `spm-examples/macOS-Shared/Package.swift` | Create |
| `spm-examples/macOS-Shared/Sources/main.swift` | Create |
| `spm-examples/iOS-Shared/Package.swift` | Create |
| `spm-examples/iOS-Shared/Sources/main.swift` | Create |
| `spm-examples/visionOS-Shared/Package.swift` | Create |
| `spm-examples/visionOS-Shared/Sources/main.swift` | Create |
| `.github/workflows/test-spm.yaml` | Add shared jobs |

### 5. Checksums

| xcframework | checksum |
|-------------|----------|
| macOS static | `89769c25a63985e2ab7a12e72215c173c5078e49dc4a2273cb84b75e587d7b96` |
| macOS shared | `9d1d49b7c5ba7d5ccff048aff3f0c40431f8232b67259df9ab7f85d76e57cb75` |
| iOS static | `985deaff345c7bcfbe4979b2daeec09d7a745b1e9cb73f37f4077364eb578e62` |
| iOS shared | `0f771394c109d2f1fd6b28bfdf197bda253e67be11a1f7b2b60559b200a84671` |
| visionOS static | `206cdc2f23a1679aa3b3a91a74a866fad56a7ea50709fe5d4a67fb9b868c6234` |
| visionOS shared | `8cf35459c30f05f8e764035fc74e76d7716d06bf405847b1e7acf8278424a2d1` |

### 6. What this achieves

- iOS projects only download the iOS xcframework, not macOS + visionOS
- visionOS projects only download visionOS xcframework
- Users choose `OnnxRuntime` (static) or `OnnxRuntime-Shared` (dynamic) per platform
- `.when(platforms:)` ensures unused xcframeworks are never downloaded
