// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NeuphloWidget",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "NeuphloWidget", targets: ["NeuphloWidget"])
    ],
    targets: [
        .target(name: "NeuphloWidget")
    ]
)
