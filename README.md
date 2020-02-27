# Drawer View Controller

The drawer view controller is an UI designed very similarly to what is used in Apple maps and stocks and Google Maps.

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding DrawerViewController as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/kevcodex/DrawerViewController.git", from: "1.0.0")
]
```

## Potential Improvements

- [ ] Allow client customization for sizing during horizontal transitioning
- [ ] Allow handle width/height client customization
- [ ] Add cocoapods and carthage
- [ ] Allow use of auto layout for drawer layout rather than set values
- [ ] Create a "navigation drawer controller" with a custom animation similar to Apple maps to transition from one drawer to another
- [ ] Consider having built in blur or opacity views that will automatically change based on points rather than client needing to make one
- [ ] Consider refactoring DrawerScrollContentHandler to make it better 
