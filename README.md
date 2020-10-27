# Drawer View Controller

The drawer view controller is a simple UI designed very similarly to what is used in Apple maps and stocks and Google Maps.

## Installation

### Cocoapods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DrawerViewController', '0.0.10'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding DrawerViewController as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/kevcodex/DrawerViewController.git", from: "1.0.0")
]
```

## Getting Started

Adding a new drawer to a view controller is just a few simple lines. By default the drawer will show a gray handle and its positions will be based on the `DefaultDrawerLayout` class.

```swift
import UIKit
import DrawerViewController

class ViewController: UIViewController {
    
    // Create the drawer
    let drawer = DrawerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Create the content view controller
        let contentViewController = UIViewController()
        
        // Set the drawer delegate to allow for customization and callbacks
        drawer.delegate = self
        
        // Add the drawer to the "container"
        drawer.add(to: self)
        
        // Add the content view to the drawer
        drawer.set(contentViewController: contentViewController)
        
        // Show the drawer at the desired position
        drawer.showDrawerView(at: .bottom, animated: true)
    }
}

extension ViewController: DrawerViewControllerDelegate {

}
```

## Potential Improvements

- [ ] Allow client customization for sizing during horizontal transitioning
- [ ] Allow handle width/height client customization
- [ ] Add carthage
- [ ] Allow use of auto layout for drawer layout rather than set values
- [ ] Create a "navigation drawer controller" with a custom animation similar to Apple maps to transition from one drawer to another
- [ ] Consider having built in blur or opacity views that will automatically change based on points rather than client needing to make one
- [ ] Consider refactoring DrawerScrollContentHandler to make it better. I think it can be done based on the gesture of the scroll view rather than using the delegates. 
