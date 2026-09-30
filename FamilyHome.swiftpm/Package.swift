// swift-tools-version: 5.9

// This is a Swift Playgrounds app package. Open the FamilyHome.swiftpm
// folder in Xcode 15+ (Mac) or Swift Playgrounds (Mac/iPad) to run it.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "FamilyHome",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "Family Home",
            targets: ["AppModule"],
            bundleIdentifier: "com.robinbannis.familyhome",
            teamIdentifier: "",
            displayVersion: "0.1",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .heart),
            accentColor: .presetColor(.green),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .locationWhenInUse(purposeString: "Family Home shows your location to family members you choose to share with.")
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources"
        )
    ]
)
