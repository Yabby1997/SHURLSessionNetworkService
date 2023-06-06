// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SHURLSessionNetworkService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SHURLSessionNetworkService",
            targets: ["SHURLSessionNetworkService"]),
    ],
    dependencies: [
         .package(url: "https://github.com/Yabby1997/SHNetworkServiceInterface", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "SHURLSessionNetworkService",
            dependencies: [
                .product(name: "SHNetworkServiceInterface", package: "SHNetworkServiceInterface"),
            ]),
    ]
)
