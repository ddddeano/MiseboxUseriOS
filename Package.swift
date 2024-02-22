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
        .package(url: "https://github.com/ddddeano/misebox-ios-global-pkg", from: "1.0.4")
    ],
    targets: [
        .target(
            name: "MiseboxiOSMiseboxUser",
            dependencies: [
                "FirebaseiOSMisebox",
                "MiseboxiOSGlobal"
            ]
        ),
        .testTarget(
            name: "MiseboxiOSMiseboxUserTTests",
            dependencies: ["MiseboxiOSMiseboxUser"]),
    ]
)
x-xcode-log://301E1985-97A6-4328-AF39-A7296D081945 product 'MiseboxiOSGlobal' required by package 'miseboxuserios' target 'MiseboxiOSMiseboxUser' not found.
