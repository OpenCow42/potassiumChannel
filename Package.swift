// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "potassiumChannel",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "PotassiumChannelCore",
            targets: ["PotassiumChannelCore"]
        ),
        .library(
            name: "PotassiumKDrive",
            targets: ["PotassiumKDrive"]
        ),
        .library(
            name: "PotassiumMail",
            targets: ["PotassiumMail"]
        ),
        .library(
            name: "PotassiumKChat",
            targets: ["PotassiumKChat"]
        ),
        .library(
            name: "PotassiumURLShortener",
            targets: ["PotassiumURLShortener"]
        ),
        .library(
            name: "PotassiumOAuth",
            targets: ["PotassiumOAuth"]
        ),
    ],
    targets: [
        .target(
            name: "PotassiumChannelCore"
        ),
        .target(
            name: "PotassiumKDrive",
            dependencies: ["PotassiumChannelCore"]
        ),
        .target(
            name: "PotassiumMail",
            dependencies: ["PotassiumChannelCore"]
        ),
        .target(
            name: "PotassiumKChat",
            dependencies: ["PotassiumChannelCore"]
        ),
        .target(
            name: "PotassiumURLShortener",
            dependencies: ["PotassiumChannelCore"]
        ),
        .target(
            name: "PotassiumOAuth"
        ),
        .testTarget(
            name: "PotassiumChannelCoreTests",
            dependencies: ["PotassiumChannelCore"]
        ),
        .testTarget(
            name: "PotassiumKDriveTests",
            dependencies: ["PotassiumChannelCore", "PotassiumKDrive"]
        ),
        .testTarget(
            name: "PotassiumMailTests",
            dependencies: ["PotassiumChannelCore", "PotassiumMail"]
        ),
        .testTarget(
            name: "PotassiumKChatTests",
            dependencies: ["PotassiumChannelCore", "PotassiumKChat"]
        ),
        .testTarget(
            name: "PotassiumURLShortenerTests",
            dependencies: ["PotassiumChannelCore", "PotassiumURLShortener"]
        ),
        .testTarget(
            name: "PotassiumOAuthTests",
            dependencies: ["PotassiumOAuth"]
        ),
    ]
)
