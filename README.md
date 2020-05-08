# Flow

<p align="left">
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-Swift_4.2-green" alt="Swift5" /></a>
 <a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-2.10.0-blue.svg" alt="CocoaPods compatible" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
 <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
 <a href="https://mobileup.ru/"><img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT" /></a>
</p>

Simple and flexible navigation library.

## Names

- Flow
- FlowX
- Compass
- Mars
- Neks
- FlowBox
- HyperFlow
- Tavigation
- Lighthouse
- Nebuchadnezzar
- Maze
- Eith
- RocketX
- Pipe
- PipePiper

## Features

- Simple navigation commands
- Provide back navigation results
- Can be painlesly added to ongoing project
- Can be used alongside segues and default view controllers navigation
- Architecture agnostic
- Unifide all navigation comands
- Navigate back to arbitrary controller
- Can be used alongside accesability navigation (back, dismiss)

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

### Forward Navigation

Forward navigation API is very similar to default `UIVewController` navigation.

#### Present controller

```swift
let controller: UIViewController = ...

router.present(controller, animated: true, completion: { ... })
```

#### Push controller in current navigation controller

```swift
router.push(controller, animated: true, completion: { ... })
```

#### Set an array of controllers to current navigation controller

```swift
let controllers: [UIViewController] = ...

router.push(controllers, animated: true, completion: { ... })
```

**Note:** completion block gets called right after the transition completes.

### Backward Navigation

#### Back to arbitrary controller in navigation tree

```swift
router.backTo(
    to: ViewController.self,
    animated: true,
    condition: { $0.id == 3 },
    prepare: { controller in ... },
    completion: { controller in ... }
)
```

We should provide target controller type and condition, in case that **more than one** controller of such type in back stack.

#### Back to previous controller in navigation tree

```swift
router.backTo(
    animated: true,
    prepare: { controller in ... },
    completion: { controller in ... }
)
```

#### Back to window root controller

```swift
router.backToWindowRoot(
    animated: true,
    prepare: { controller in ... },
    completion: { controller in ... }
)
```

**Note:** prepare block gets called just before transition begins and can be used for returning some data to target controller.

### Inplace Navigation

#### Replace current controller

```swift
router.replace(to: controller, animated: true, completion: { ... })
```

Works even with window root view controller.

#### Set current window root view controller

```swift
router.setWindowRoot(controller, animated: true, completion: { ... })
```

## Advanced Usage

### Custom container controllers

In case of custom contrainer controllers in navigation tree, developer shoud adopt them to [`ContainerController` protocol]().

### Functionality Extension

Feel free to extend or subclass `Router` in order to add new navigation commands or override them.

## Requirements

- Swift 4.2 +
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
