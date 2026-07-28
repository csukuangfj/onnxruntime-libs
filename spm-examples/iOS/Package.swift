// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "VersionDemo",
  platforms: [.iOS(.v15)],
  dependencies: [
    .package(url: "https://github.com/csukuangfj/onnxruntime-libs", branch: "master")
  ],
  targets: [
    .executableTarget(
      name: "VersionDemo",
      dependencies: [
        .product(name: "onnxruntime-ios", package: "onnxruntime-libs")
      ],
      linkerSettings: [
        .linkedLibrary("c++")
      ]
    )
  ]
)
