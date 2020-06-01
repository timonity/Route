# Route

<p align="left">
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-Swift_4.2-green" alt="Swift5" /></a>
 <a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-1.0.0-blue.svg" alt="CocoaPods compatible" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
 <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
 <a href="https://"><img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT" /></a>
</p>

Easy navigation in iOS application. Just works as expected.

## Features

- Simple navigation commands
- Navigate back to **any** controller with result
- Jump to **any** controller in navigation tree
- Super friendly to existing project navigation
- Can be painlessly added to ongoing project
- Architecture agnostic
- Lightweight

Router doesn't hold any state, all values required for navigation are calculated on the fly based on `UIViewController` properties. So it's fully compatible with existing project navigation system. You can easily mix router navigation command calls with performing segues or push/present/dismiss/etc. So it can be painlesly added to any ongoing project.

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

#### Present controller

```swift
let controller: UIViewController = ...

router.present(controller, animated: true, completion: { ... })
```

#### Push controller in current navigation controller

```swift
router.push(controller, animated: true, completion: { ... })
```

**Note:** completion block gets called right after the transition completes.

### Backward Navigation

#### Back to arbitrary controller in navigation tree

```swift
router.back(
    to: ViewController.self,
    animated: true,
    condition: { $0.id == 3 },
    prepare: { controller in ... },
    completion: { controller in ... }
)
```

Provide condition in addition to target controller type, in case that **more than one** controller of such type in back stack.

#### Back to previous controller in navigation tree

```swift
router.back(
    animated: true,
    prepare: { controller in ... },
    completion: { controller in ... }
)
```

#### Back to window root

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
router.replace(
    with: controller,
    animated: true,
    completion: { ... }
)
```

**Note:** replace even window root view controller.

#### Set current window root view controller

```swift
router.setWindowRoot(
    controller,
    animated: true,
    completion: { ... }
)
```

#### Jump to controller

Go to view controller wherever it positioned in navigation tree.

```swift
router.jump(
    to: ViewController.self,
    animated: true,
    condition: { $0.id == 3 },
    prepare: { controller in ... },
    completion: { controller in ... }
)
```

### Navigation Tree Info

#### Find controller

```swift
let controller = router.find(ViewController.self, condition: { $0.id == 3 })
```

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
let controllers = router.topStack
```

## Custom container controllers

Custom container controller in navigation tree must adopt one of three container controller protocols.

### Simple container

If container contains just one child controller it must implement [`ContainerController`]() protocol ([example]()).

### Stack container

If container contains stack of child controllers, like `UINavigationController`, it must implement [`StackContainerController`]() protocol ([example]()).

### Flat container

If container contains child controller at one level, like `UITabBarController` or `UIPageViewController`, it must implement ['FlatContainerController']() protocol. See [tab bar example]() or [page controller example]().

## Requirements

- Swift 4.2 +
- iOS 9.0 +

## Istallation

### CocoaPods

Add the following to `Podfile`:

```ruby
pod 'Route'
```

### Manual

Download and drag files from Source folder into your Xcode project.

## License

Route is distributed under the [MIT License](https://qwe.qwe/).
