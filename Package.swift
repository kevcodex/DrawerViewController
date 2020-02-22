// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DrawerViewController",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "DrawerViewController",
            targets: ["DrawerViewController"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DrawerViewController",
            dependencies: [],
            path: "Source")
    ]
)
