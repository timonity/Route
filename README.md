# Flow
<p align="left">
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-Swift_4.0-green" alt="Swift5" /></a>
	<a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-2.10.0-blue.svg" alt="CocoaPods compatible" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
	<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
	<a href="https://mobileup.ru/"><img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT" /></a>
</p>

Simple and flexible navigation library.

## Features
- Simple navigation commands
- Provide back navigation results
- Can be added to ongoing project
- Can be used alongside segues and default view controllers navigation
- Architecture agnostic
- Unificate back navigation comands
- Back navigation to arbitrary controller


## Adding

Init router, for example in AppDelegate:
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var router = Router(window: window)
}
```

**Note:** actually router can be created **without** window. Window only required for setting window root controller functionality.

Then provide access point to router. In order to use router navigation commands you must provide controller, from which navigation performs, i.e. `currentController` property.

```swift
extension UIViewController {
    
    var router: Router {
        
        let keyRouter = (UIApplication.shared.delegate as! AppDelegate).router
        
        keyRouter.currentController = self
        
        return keyRouter
    }
}
```
**Note:** in case of multy window application we can simply provide routere for current visible window.


## Basic Usage

### Forward

Forward navigation is API is very similar to default `UIVewController` navigation. To present a new controller:

```swift
let controller: UIViewController = ...

router.present(controller, animated: true, completion: { ... })
```

Push controller in current navigation controller:
```swift
router.push(controller, animated: true, completion: { ... })
```

or set an array of controllers:
```swift
let controllers: [UIViewController] = ...

router.push(controllers, animated: true, completion: { ... })
```

Completion block gets called right after transition completes.

### Backward

Back to any view controller in all navigation tree. We should provide target controller type and condition, in case of **more than one** controller of such type in stack. Prepare block gets called just before transition and can be use for returning some data. Compleiton block called right after transition finish

```swift
router.backTo(
    to: ViewController.self,
    animated: true,
    condition: { $0.id == 3 },
    prepare: { $0.someData = ... },
    completion: { $0.showAlert(with: title) }
)
```

Back to previous controller in navigation tree:
```swift
router.backTo(
    animated: true,
    prepare: { $0.someData = ... },
    completion: { $0.showAlert(with: title) }
)
```

### Replace

Replace current controller (even window root view controller).

```swift
router.replace(to: controller, animated: true, completion: { ... })
```

### Root
Set current key window root view controller.

```swift
router.setWindowRoot(controller, animated: false, completion: { ... })
```

## Advanced Usage

### Custom container controllers

In case of custom contrainer controllers in navigation tree, developer shoud adopt them to `ContainerController` protocol.

```swift
protocol ContainerController {
    
    var visibleController: UIViewController? { get }
}
```

### Functionality Extension

Feel free to subclass `Router` and add new navigation commands to existing ones or override them.


## Requirements
- Swift 4.0 +
- iOS 9.0 +


## Istallation

### CocoaPods
Add the following to `Podfile`:
```ruby
pod 'Flow'
```

### Manual
Download and drag files from Source folder into your Xcode project.


## License
Flow is distributed under the [MIT License](https://qwe.qwe/).