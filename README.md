# Route

<p align="left">
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-Swift_4.2-green" alt="Swift5" /></a>
 <a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-2.10.0-blue.svg" alt="CocoaPods compatible" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
 <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
 <a href="https://mobileup.ru/"><img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT" /></a>
</p>

Easy navigation in iOS application. Just works as expected. Designed to be extended.

## Features

- Simple and unified navigation commands
- Navigate back to **any** controller with result
- Architecture agnostic
- Super friendly to existing project navigation
- Easy to extend
- Can be painlessly added to ongoing project
- Lightweight & Stateless

Router - proxy to default controller navigation. It doesn't hold any state, all values such as back target controller, top controller or back navigation stack are calculated on the fly based on `UIViewController` properties. So it's fully compatible with existing project navigation system (default, storyboard or custom) and accesability gestures navigation. Thus can be painlesly added to ongoing project.

## Add

Provide access point to router (from view controller, for example):

```swift
extension UIViewController {

    var router: Router {
        return Router(window: UIApplication.shared.keyWindow, controller: self)
    }
}
```

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

**Note:** prepare block gets called just before the transition begins and can be used for returning some data to target controller.

### Inplace Navigation

#### Replace current controller

```swift
router.replace(to: controller, animated: true, completion: { ... })
```

**Note:** replace even window root view controller.

#### Set current window root view controller

##### From any view controller

```swift
router.setWindowRoot(controller, animated: true, completion: { ... })
```

##### From AppDelegate

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var router = Router(window: window)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Setup window

        router.setWindowRoot(controller, animated: true, completion: { ... })

        return true
    }
}
```

### Navigation Stack Info

#### Top view controller

```swift
let controller = router.topController
```

#### Back stack

Get back navigation stack from current controller to window root:

```swift
let controllers = router.backStack
```

#### Stack from root to top controller

```swift
let controllers = router.stack
```

## Advanced Usage

### Custom container controllers

In case of custom contrainer controllers in navigation tree, developer shoud adopt them to [`ContainerController` protocol]().

### Functionality Extension

Feel free to extend or subclass `Router` in order to add new navigation commands or override them.

### Router creation

Actually router can be created **without** window. Window only required for setting window root controller functionality.

Router can be created without **controller**, which is ok to set window root view controller.


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
