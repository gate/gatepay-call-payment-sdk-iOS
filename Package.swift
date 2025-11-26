// swift-tools-version: 5.4
// GateOpenSDK 二进制分发 Package.swift 配置

import PackageDescription

let package = Package(
    name: "GateOpenSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "GateOpenSDK",
            targets: ["GateOpenSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "GateOpenSDK",
            url: "https://github.com/gate/gatepay-call-payment-sdk-iOS/releases/download/1.0.0/GateOpenSDK-1.0.0.xcframework.zip",
            checksum: "d4f8c8aea079e121bedd48a69ce0e1e664e5d9cd471826eea6f748885735d460"
        )
    ]
)
