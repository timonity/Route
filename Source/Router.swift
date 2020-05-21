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

open class Router {
    
    // MARK: - Private properties
    
    private weak var window: UIWindow?

    private var windowRootController: UIViewController? {
        
        guard let windowRoot = keyWindow?.rootViewController else {
            
            print("Root view controller for window not found")
            
            return nil
        }
        
        return windowRoot
    }
    
    private var keyWindow: UIWindow? {
        
        guard let window = window else {
            
            print("Current window not found. In order to use ... functionality Router must be inited with window")
            
            return nil
        }
        
        return window
    }
    
    private var keyController: UIViewController? {
        
        guard let controller = currentController else {
            
            assertionFailure("Current controller not found")
            
            return nil
        }
        
        return controller
    }
    
    private var keyStackContainerController: StackContainerController? {
        
        guard let container = keyController?.parent as? StackContainerController else {
            
            print("Missing `UINavigationController` for current controller")
            
            return nil
        }
        
        return container
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

    public var stack: [UIViewController] {
        fatalError("Not implemented")
    }
    
    // MARK: - Private methods
    
    private func getBackStack() -> [UIViewController] {
        
        let result = findControllerInNavigationTree(type: UIViewController.self) { _ in
            
            return false
        }
        
        return result.stack.reversed()
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
                return condition?(candidate) ?? true
                
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
        
        var nextResult = result
        nextResult.stack.append(current)
        
        if condition(current) {
            
            nextResult.target = current
            
            return nextResult

        } else if let parent = current.parent {
            
            let next: UIViewController
            
            if let container = parent as? StackContainerController {
                            
                if let previous = container.getPreviousController(for: current) {
                    
                    next = previous
                    
                    nextResult.action.popTo = previous
                    nextResult.lastContentController = previous
                    
                } else {
                    
//                    Не покрывает кейс когда парент является и контейнерои и контент контроллером
//                    nextResult.lastContentController = parent
                    next = parent
                }
                
            } else {
                
                nextResult.lastContentController = parent
                next = parent
            }
            
            return findControllerInNavigationTree(
                 condition: condition,
                 current: next,
                 result: nextResult
             )
        
        } else if let presenting = current.presentingViewController {
            
            nextResult.action.dismiss = presenting
            nextResult.action.popTo = nil
            
            if
                let container = presenting as? ContainerController,
                let content = container.visibleContentController
            {
                nextResult.lastContentController = content
                
                return findControllerInNavigationTree(
                    condition: condition,
                    current: content,
                    result: nextResult
                )
                
            } else {
                
                nextResult.lastContentController = presenting
                
                return findControllerInNavigationTree(
                    condition: condition,
                    current: presenting,
                    result: nextResult
                )
            }
            
        } else {
            
            nextResult.target = nil
            
            return nextResult
        }
    }
    
    // MARK: - Public methods
    
    public init(window: UIWindow?) {
        self.window = window
    }

    public convenience init(window: UIWindow?, controller: UIViewController) {
        self.init(window: window)

        currentController = controller
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
        
        if
            let controllerToPop = action.popTo,
            let container = controllerToPop.parent as? StackContainerController
        {
            let isAnimated = (action.dismiss == nil) ? animated : false
            container.backTo(controllerToPop, animated: isAnimated, completion: completion)
        }
    }
    
    // MARK: Forward Navigation
    
    public func push(
        _ controllers: [UIViewController],
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        keyStackContainerController?.push(
            controllers: controllers,
            animated: animated,
            completion: completion
        )
    }
    
    public func push(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        keyStackContainerController?.push(
            controller: controller,
            animated: animated,
            completion: completion
        )
    }
    
    public func present(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        keyController?.present(controller, animated: animated, completion: completion)
    }
    
    // MARK: Backward Navigation
    
    public func backTo<T: UIViewController>(
        _ controllerType: T.Type,
        animated: Bool = true,
        condition: ((T) -> Bool)? = nil,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil,
        failure: Completion? = nil
    ) {
        let navigationResult = findControllerInNavigationTree(type: controllerType, condition: condition)
        
        guard let targetController = navigationResult.target as? T else {
            failure?()

            print("Target controller of type `\(controllerType)` not found in navigation tree")
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
        completion: ((T) -> Void)? = nil,
        failure: Completion? = nil
    ) {
        backTo(
            T.self,
            animated: animated,
            condition: { [weak self] (controller) -> Bool in
                if controller is ContainerController { return false }
                
                return self?.keyController !== controller
            },
            prepare: prepare,
            completion: completion,
            failure: failure
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
        guard let navigationRoot = keyStackContainerController?.root else { return }
        
        backTo(
            T.self,
            animated: animated,
            condition: { $0 === navigationRoot },
            prepare: prepare,
            completion: completion
        )
    }
}

// MARK: - Inplace Navigation

typealias TraceNode = Node<Trace>

extension Router {

    // MARK: Public properties

    public var tree: Node<Trace>? {
        guard let root = windowRootController else { return nil }

        let rootTrace = Trace(
            controller: root,
            openType: .windowRoot,
            isOnTopWay: true
        )

        let rootNode = Node<Trace>(value: rootTrace)

        growTree(leaf: rootNode, shouldCheckPresent: true)

        return rootNode
    }

    // MARK: Private methods

    private func growTree(leaf: Node<Trace>, shouldCheckPresent: Bool) {
        let lastController = leaf.value.controller

        if let stackContaier = lastController as? StackContainerController {
            var lastInStack = leaf

            for controller in stackContaier.controllers {
                let trace = Trace(
                    controller: controller,
                    openType: .pushed(stackContaier),
                    isOnTopWay: shouldCheckPresent
                )

                let newNode = Node<Trace>(value: trace)
                lastInStack.addChild(newNode)

                lastInStack = newNode

                // Check childs for container in case:
                // |->[content]->[container]->[content]
                let isLast = controller == stackContaier.controllers.last

                if controller is ContainerController && isLast == false {
                    growTree(leaf: newNode, shouldCheckPresent: false)
                }
            }

            growTree(leaf: lastInStack, shouldCheckPresent: shouldCheckPresent)

        } else if let flatContaier = lastController as? FlatContainerController {

            for controller in flatContaier.controllers {
                let isVisible = controller == flatContaier.visibleController

                let trace = Trace(
                    controller: controller,
                    openType: .sibling(flatContaier),
                    isOnTopWay: isVisible
                )

                let newNode = Node<Trace>(value: trace)
                leaf.addChild(newNode)

                growTree(leaf: newNode, shouldCheckPresent: isVisible)
            }

        } else if
            let generalContainer = lastController as? ContainerController,
            let controller = generalContainer.visibleController
        {
            let trace = Trace(
                controller: controller,
                openType: .child(generalContainer),
                isOnTopWay: true
            )

            let newNode = Node<Trace>(value: trace)
            leaf.addChild(newNode)

            growTree(leaf: newNode, shouldCheckPresent: true)

        } else if
            let presented = lastController.presentedViewController,
            shouldCheckPresent
        {
            let trace = Trace(
                controller: presented,
                openType: .presented(lastController),
                isOnTopWay: true
            )

            let node = TraceNode(value: trace)
            leaf.addChild(node)

            growTree(leaf: node, shouldCheckPresent: true)
        }
    }

    // MARK: Public methods

    public func replace(
        to controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        guard let current = keyController else { return }

        if let container = current.parent as? ContainerController {
            container.replace(
                current,
                with: controller,
                animated: animated,
                completion: completion
            )

        } else if let presenting = current.presentingViewController {
            current.dismiss(animated: animated, completion: nil)
            presenting.present(controller, animated: animated, completion: completion)

        } else if findPreviousContentController(for: current)?.target == nil {
            setWindowRoot(controller, animated: animated)
        }
    }

    public func setWindowRoot(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        if
            let root = keyWindow?.rootViewController as? RootViewController,
            let currentRoot = root.current
        {
            root.transition(
                from: currentRoot,
                to: controller,
                animated: animated,
                completion: completion
            )

        } else {
            let root = RootViewController()
            root.insert(controller)

            keyWindow?.rootViewController = root

            completion?()
        }
    }

    public func jumpTo<T: UIViewController>(
        _ controller: T.Type,
        animated: Bool = true,
        condition: ((T) -> Bool)? = nil,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil,
        failure: Completion? = nil
    ) {
        var pathToVisible = tree?.findPath { $0.controller == self.topController }

        var pathToTarget = tree?.findPath { (trace) -> Bool in
            guard let pretender = trace.controller as? T else { return false }

            return condition?(pretender) ?? true
        }

        while pathToVisible?.children.first == pathToTarget?.children.first {
            assert((pathToVisible?.children.count ?? 0) < 2, "Invalid children count")
            assert((pathToTarget?.children.count ?? 0) < 2, "Invalid chilrden count")

            pathToVisible = pathToVisible?.children.first
            pathToTarget = pathToTarget?.children.first
        }

        // Go back animations

        var backActions = [Action]()

        for node in NodeIterator(root: pathToVisible!) {
            if case let OpenType.presented(controller) = node.value.openType {
                backActions.append(.dismiss(controller))

                break
            }
        }

        // Go forward animations

        var forwardActions: [Action] = []

        for node in NodeIterator(root: pathToTarget!) {

            switch node.value.openType {

            case .windowRoot:
                break

            case .presented(_):
                assertionFailure("In forward pass shouldn't be presented controllers")

            case .child(_):
                break

            case .pushed(_):
                if node.isLeaf {
                    forwardActions.append(
                        .popTo(node.value.controller)
                    )
                }

            case .sibling(_):
                forwardActions.append(
                    .select(node.value.controller)
                )
            }
        }

        // Performs actions

        let allActions = backActions + forwardActions

        performActions(allActions)
    }

    private func performActions(_ actions: [Action]) {

        actions.forEach { (action) in
            action.apply()
        }
    }

    public func makeVisible(
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        jumpTo(
            UIViewController.self,
            animated: animated,
            condition: { $0 == self.currentController },
            prepare: nil,
            completion: { _ in completion?() },
            failure: nil
        )
    }
}

// MARK: Animation Action

enum Action {

    case dismiss(UIViewController)
    case popTo(UIViewController)
    case select(UIViewController)

    func apply() {

        switch self {

        case .dismiss(let controller):
            controller.dismiss(animated: true, completion: nil)

        case .popTo(let controller):
            controller.stackContaier?.backTo(controller, animated: true, completion: nil)

        case .select(let controller):
            controller.flatContainer?.selectController(controller)
        }

    }
}
