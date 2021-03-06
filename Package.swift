// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Perfect_Service",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",    majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git",      majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Crypto.git",        majorVersion: 1, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-WebSockets.git",    majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/huhuegg/Perfect-Redis.git",               majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git",         majorVersion: 2, minor: 1),
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git",               majorVersion: 3, minor: 1),
        .Package(url: "https://github.com/iamjono/SwiftMD5.git",                    majorVersion: 1, minor: 0)
    ]
)
