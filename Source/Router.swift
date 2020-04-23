//
//  Router.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 13.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

public typealias Condition = (UIViewController) -> Bool
public typealias Completion = () -> Void

open class Router: NSObject {
    
    // MARK: Akk
    
    private var transitions: Set<Transition> = []
    
    // MARK: - Private properties
    
    private let window: UIWindow?
    
    private var windowRootController: UIViewController? {
        
        return window?.rootViewController
    }
    
    private var keyController: UIViewController? {
        
        guard let controller = currentController else {
            
            assertionFailure("Current controller not found")
            
            return nil
        }
        
        return controller
    }
    
    private var keyNavigationController: UINavigationController? {
        
        guard let navigation = keyController?.navigationController else {
            
            print("Missing `UINavigationController` for current controller")
            
            return nil
        }
        
        return navigation
    }
    
    // MARK: - Public properties
    
    public weak var currentController: UIViewController?
    
    public var topController: UIViewController? {
        
        guard let root = windowRootController else { return nil }
        
        return getTopController(for: root)
    }
    
    public var backStack: [UIViewController] {
        
        return getBackStack().filter { !($0 is RootViewController) }
    }
    
    // MARK: - Private methods
    
    private func getBackStack() -> [UIViewController] {
        
        let res = findControllerInNavigationTree(type: UIViewController.self) { _ in
            
            return false
        }
        
        return res.stack.reversed()
    }
    
    // MARK: Forward Search
    
    private func getTopController(for controller: UIViewController) -> UIViewController {
        
        if let presented = controller.presentedViewController {
            
            return getTopController(for: presented)
            
        } else if let container = controller as? ContainerController, let visible = container.visibleController {
            
            return getTopController(for: visible)
            
        } else {
            
            return controller
        }
    }
    
    // MARK: Backward Search
    
    private func findPreviousContentController(
        for controller: UIViewController
    ) -> BackResult? {
        
        return findControllerInNavigationTree(for: controller) { (c) -> Bool in
            
            if c is ContainerController {
                
                return false
                
            } else if controller == c {
                
                return false
                
            } else {
                
                return true
            }
        }
    }
    
    private func findControllerInNavigationTree<T: UIViewController>(
        type: T.Type,
        condition: ((T) -> Bool)? = nil
    ) -> BackResult {
        
        guard let current = keyController else { return BackResult(action: BackAction()) }
        
        return findControllerInNavigationTree(for: current) { (controller) -> Bool in
            
            if let candidate = controller as? T {
                
                if let condition = condition {
                    
                    return condition(candidate)
                    
                } else {
                    
                    return true
                }
                
            } else {
                
                return false
            }
        }
    }
    
    private func findControllerInNavigationTree(
        for controller: UIViewController,
        condition: Condition
    ) -> BackResult {
        
        return findControllerInNavigationTree(
            condition: condition,
            current: controller,
            result: BackResult(action: BackAction())
        )
    }
    
    private func findControllerInNavigationTree(
        condition: Condition,
        current: UIViewController,
        result: BackResult
    ) -> BackResult {
        
        var newResult = result
        newResult.stack.append(current)
        
        if condition(current) {
            
            newResult.target = current
            
            return newResult

            
        } else if let parent = current.parent {
            
            if
                let navigation = parent as? UINavigationController,
                let prevController = navigation.findPrevioudController(for: current)
            {
                
                newResult.action.popTo = prevController
                newResult.lastContentController = prevController
                
                return findControllerInNavigationTree(condition: condition, current: prevController, result: newResult)
                
            } else {
                
                // Не покрывает кейс когда парент контент контроллер для lastContentController
                
                // Возможно это покрыват кейс, когда парент = табБарКонтроллер
                return findControllerInNavigationTree(condition: condition, current: parent, result: newResult)
            }
        
        } else if let presenting = current.presentingViewController {
            
            newResult.action.dismiss = presenting
            newResult.action.popTo = nil
            
            if let container = presenting as? ContainerController, let content = container.visibleContentController {
                
                newResult.lastContentController = content
                
                return findControllerInNavigationTree(condition: condition, current: content, result: newResult)
                
            } else {
                
                newResult.lastContentController = presenting
                
                return findControllerInNavigationTree(condition: condition, current: presenting, result: newResult)
            }
            
        } else {
            
            newResult.target = nil
            
            return newResult
        }
    }
    
    // MARK: - Public methods
    
    public init(window: UIWindow?) {
        
        self.window = window
    }
    
    open func navigate(
        with action: BackAction,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        if let controllerToDismiss = action.dismiss {
            
            let c = (action.popTo == nil) ? completion : nil
            
            controllerToDismiss.dismiss(animated: animated, completion: c)
        }
        
        if let controllerToPop = action.popTo {
            
            let isAnimated = (action.dismiss == nil) ? animated : false
            
            controllerToPop.navigationController?.pop(
                to: controllerToPop,
                animated: isAnimated,
                completion: completion
            )
        }
    }
    
    // MARK: Forward Navigation
    
    // https://qnoid.com/2019/02/15/How_to_replace_the_-rootViewController-_of_the_-UIWindow-_in_iOS.html
    public func setWindowRoot(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        guard let window = window else {
            
            print("Current window not found")
            
            return
        }
        
        if
            let root = window.rootViewController as? RootViewController,
            let child = root.childViewControllers.first
        {
            
            root.transition(from: child, to: controller, completion: completion)
            
        } else {
            
            let root = RootViewController()
            
            window.rootViewController = root
            
            root.insert(controller: controller)
            
            completion?()
        }
        
        
//        window.rootViewController = controller
//        window.rootViewController?.dismiss(animated: false, completion: nil)
//
//
//        UIView.transition(
//            with: window,
//            duration: 0.3,
//            options: .transitionCrossDissolve,
//            animations: {  },
//            completion: { isCompleted in completion?() }
//        )
    }
    
    
    public func push(
        _ controllers: [UIViewController],
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        keyNavigationController?.push(controllers: controllers, animated: animated, completion: completion)
    }
    
    public func push(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        keyNavigationController?.push(controller: controller, animated: animated, completion: completion)
    }
    
    public func present(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        keyController?.present(controller, animated: animated, completion: completion)
    }
    
    // MARK: Inplace Navigation
    
    public func replace(
        to controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        guard let current = keyController else { return }
        
        if let navigationController = keyController?.navigationController {
            
            if controller.navigationController != nil {
                
                print("Replacing controller in navigation stack with controller in another navigation stack is not supported")
                
                return
            }
            
            navigationController.replace(
                with: controller,
                animated: animated,
                completion: completion
            )
            
        } else if let presenting = current.presentingViewController {
            
            current.dismiss(animated: animated, completion: nil)
            
            presenting.present(controller, animated: animated, completion: completion)
        
        }
        else if findPreviousContentController(for: current)?.target == nil
            || findPreviousContentController(for: current)?.target is RootViewController
        {
            setWindowRoot(controller, animated: animated)
        }
    }
    
    // MARK: Backward Navigation
    
    public func backTo<T: UIViewController>(
        to: T.Type,
        animated: Bool = true,
        condition: ((T) -> Bool)? = nil,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        
        let navigationResult = findControllerInNavigationTree(type: to, condition: condition)
        
        guard let targetController = navigationResult.target as? T else {
            
            print("Target controller of type `\(to)` not found in navigation tree")
            
            return
        }
        
        prepare?(targetController)
        
        navigate(with: navigationResult.action, animated: animated) {
            
            completion?(targetController)
        }
    }
    
    public func back<T: UIViewController>(
        animated: Bool = true,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        
        backTo(
            to: T.self,
            animated: animated,
            condition: { [weak self] (controller) -> Bool in
                
                if controller is ContainerController {
                    
                    return false
                }
                
                return self?.keyController !== controller
            },
            prepare: prepare,
            completion: completion
        )
    }
    
    public func backToWindowRoot<T: UIViewController>(
        animated: Bool = true,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        
        var navigationResult = findControllerInNavigationTree(type: T.self) { _ in
            
            return false
        }
        
        navigationResult.target = navigationResult.lastContentController
        
        guard let targetController = navigationResult.target as? T else {
            
            print("Target controller of type not found in navigation tree")
            
            return
        }
        
        prepare?(targetController)
        
        navigate(with: navigationResult.action, animated: animated) {
            
            completion?(targetController)
        }
    }
    
    public func backToKeyNavigationRoot<T: UIViewController>(
        animated: Bool = true,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        
        backTo(
            to: T.self,
            animated: animated,
            condition: { $0 === self.keyNavigationController?.root },
            prepare: prepare,
            completion: completion
        )
    }
}
