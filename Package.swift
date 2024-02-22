// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiseboxiOSMiseboxUser",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MiseboxiOSMiseboxUser",
            targets: ["MiseboxiOSMiseboxUser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.0.3"),
        .package(url: "https://github.com/ddddeano/GlobalMiseboxiOS.git", from: "1.0.4")
    ],
    targets: [
        .target(
            name: "MiseboxiOSMiseboxUser",
            dependencies: [
                "FirebaseiOSMisebox",
                "GlobalMiseboxiOS"
            ]
        ),
        .testTarget(
            name: "MiseboxiOSMiseboxUserTTests",
            dependencies: ["MiseboxiOSMiseboxUser"]),
    ]
)
