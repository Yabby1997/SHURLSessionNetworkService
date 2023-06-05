// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GiphyURLSessionNetworkService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GiphyURLSessionNetworkService",
            targets: ["GiphyURLSessionNetworkService"]),
    ],
    dependencies: [
         .package(url: "https://github.com/Yabby1997/GiphyRepository", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "GiphyURLSessionNetworkService",
            dependencies: [
                .product(name: "GiphyRepository", package: "GiphyRepository")
            ]),
    ]
)
