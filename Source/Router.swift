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
    
    // MARK: Private properties
    
    private let window: UIWindow?
    
    private var windowRootController: UIViewController? {
        
        return window?.rootViewController
    }
    
    // MARK: Public properties
    
    public weak var currentController: UIViewController?
    
    // MARK: - Private methods
    
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
    
    private func findController<T: UIViewController>(
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
        
        if condition(current) {
            
            return BackResult(
                action: result.action,
                target: current,
                lastContentController: result.lastContentController
            )
            
        } else if let parent = current.parent {
            
            var newResult = result
            
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
            
            var newResult = result
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
            
            return BackResult(
                action: result.action,
                target: nil,
                lastContentController: result.lastContentController
            )
        }
    }

    
    private func navigate(
        with action: BackAction,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        if let controllerToDismiss = action.dismiss {
            
            controllerToDismiss.dismiss(animated: animated, completion: completion)
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
    
    // MARK: - Public methods
    
    public init(window: UIWindow?) {
        
        self.window = window
    }
    
    // MARK: Forward
    
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
            
            root.insert(controller: controller)
            
            window.rootViewController = root
            
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
        
        keyNavigationController?.push(controller: controller, animated: true, completion: completion)
    }
    
    public func present(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        keyController?.present(controller, animated: animated, completion: completion)
    }
    
    // MARK: Replace
    
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
    
    // MARK: Back
    
    public func backTo<T: UIViewController>(
        to: T.Type,
        animated: Bool = true,
        condition: ((T) -> Bool)? = nil,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        
        let navigationResult = findController(type: to, condition: condition)
        
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
        
        var navigationResult = findController(type: T.self) { _ in
            
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

// MARK: - Akk

extension Router {
    
    private func findNextController(
        for controller: UIViewController
    ) -> UIViewController {
        
        if let p = controller.presentedViewController {
            
            return findNextController(for: p)
            
        } else if let t = controller as? TopControllerProvider, let c = t.top {
            
            return findNextController(for: c)
            
        } else {
            
            return controller
        }
    }
}

// MARK: - Transition methods

extension Router {
    
    private func getTransitionFor(source: UIViewController, target: UIViewController) -> Transition? {
        
        return transitions.filter { $0.from === source && $0.to === target }.first
    }
    
    private func getTransitionForSource(_ controller: UIViewController) -> Transition? {
        
        return transitions.filter { $0.from === controller }.first
    }
    
    private func getTransitionForTarger(_ controller: UIViewController) -> Transition? {
        
        return transitions.filter { $0.to === controller }.first
    }
    
    private func deleteFineshedTransitions() {
        
        let finishedTransitions = transitions.filter { $0.isFinished }
        
        transitions = transitions.subtracting(finishedTransitions)
        
        print("Transitions count after clear: \(transitions.count)")
    }
    
    private func getAllControllersInStack() -> Set<UIViewController> {

        var result: Set<UIViewController> = [currentController!]

        _ = findControllerInNavigationTree(for: currentController!) { (controller) -> Bool in

            result.insert(controller)

            return false
        }

        return result
    }
}

// MARK: UINavigationControllerDelegate

extension Router: UINavigationControllerDelegate {
    
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        
    }
    
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        let animator: Animator?
        
        switch operation {
            
        case .none:
            animator = nil
            
        case .push:
            animator = getTransitionFor(source: fromVC, target: toVC)?.animator
            animator?.isOpening = true
            
        case .pop:
            animator = getTransitionFor(source: toVC, target: fromVC)?.animator
            animator?.isOpening = false
        }
        
        return animator
    }
    
    public func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        
        return nil
    }
}

// MARK: UIViewControllerTransitioningDelegate

extension Router: UIViewControllerTransitioningDelegate {
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = getTransitionFor(source: source, target: presented)?.animator
        
        animator?.isOpening = true
        
        return animator
    }
    
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = getTransitionForTarger(dismissed)?.animator
        
        animator?.isOpening = false
        
        return animator
    }
    
    public func interactionControllerForPresentation(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        
        return nil
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        
        return nil
    }
}
