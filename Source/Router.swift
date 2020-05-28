//
//  Router.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 13.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

typealias TraceNode = Node<Trace>

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

    private var pathToCurrentController: [Trace]? {
        return tree?.findPath { $0.controller == self.currentController }
    }

    private var pathToTopController: [Trace]? {
        return tree?.findPath { $0.controller == self.topController }
    }

    private var tree: Node<Trace>? {
        return getNavigationTree()
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
        return pathToCurrentController!
            .map { $0.controller }
    }
    
    private func getTopController(for controller: UIViewController) -> UIViewController {
        
        if let presented = controller.presentedViewController {
            return getTopController(for: presented)
            
        }
            else if let container = controller as? ContainerController,
            let visible = container.visibleController
        {
            return getTopController(for: visible)
            
        } else {
            return controller
        }
    }
    
    private func findPreviousContentController(
        for controller: UIViewController
    ) -> UIViewController? {
        let contentControllers = tree?
            .findPath { $0.controller == controller }?
            .filter { $0.type.isContent }
            .map { $0.controller }

        if
            let controllers = contentControllers,
            controllers.count > 1
        {
            return controllers[controllers.endIndex - 2]

        } else {
            return contentControllers?.first
        }
    }

    private func perform<T: UIViewController>(
        jumpRoute: Route,
        animated: Bool = true,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil,
        failure: Completion? = nil
    ) {
        var route = jumpRoute

        route.cutMutualParts()

        guard let action = route.action else {
            failure?()
            return
        }

        guard let target = route.target as? T else {
            failure?()
            return
        }

        prepare?(target)

        action.perform(animated: animated) {
            completion?(target)
        }
    }

    private func getPathTo<T: UIViewController>(
        _ controller: T.Type,
        condition: ((T) -> Bool)? = nil
    ) -> [Trace]? {
        let pathToTargetController = tree?.findPath { (trace) -> Bool in
            guard let pretender = trace.controller as? T else {
                return false
            }

            return condition?(pretender) ?? true
        }

        guard let pathToTarget = pathToTargetController else {
            return nil
        }

        return pathToTarget
    }

    private func getNavigationTree() -> Node<Trace>? {
        guard let root = windowRootController else {
            return nil
        }

        let rootTrace = Trace(
            controller: root,
            openType: .windowRoot,
            isOnTopWay: true
        )

        let rootNode = Node<Trace>(value: rootTrace)

        growTree(leaf: rootNode, shouldCheckPresent: true)

        return rootNode
    }

    private func growTree(leaf: Node<Trace>, shouldCheckPresent: Bool) {
        let lastController = leaf.value.controller

        if let stackContaier = lastController as? StackContainerController {
            var lastInStack = leaf

            // Add all controllers in stack to tree
            for controller in stackContaier.controllers {
                let trace = Trace(
                    controller: controller,
                    openType: .pushed(stackContaier),
                    isOnTopWay: shouldCheckPresent
                )

                let newNode = Node<Trace>(value: trace)
                lastInStack.addChild(newNode)

                lastInStack = newNode

                // Check childs for container in the midle of stack:
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

    // MARK: - Public methods
    
    public init(window: UIWindow?) {
        self.window = window
    }

    public convenience init(window: UIWindow?, controller: UIViewController) {
        self.init(window: window)

        currentController = controller
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
        keyController?.present(
            controller, animated: animated,
            completion: completion
        )
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
        guard let pathToCurrent = pathToCurrentController else {
            return
        }

        let pathToTargetController = pathToCurrent.prefix(through: { (trace) -> Bool in
            guard let pretender = trace.controller as? T else {
                return false
            }

            return condition?(pretender) ?? true
        })

        guard let pathToTarget = pathToTargetController else {
            return
        }

        let jumpTraces = Route(
            pathToVisible: pathToCurrent,
            pathToTarget: pathToTarget
        )

        perform(
            jumpRoute: jumpTraces,
            animated: animated,
            prepare: prepare,
            completion: completion,
            failure: failure
        )
     }

     public func back<T: UIViewController>(
         animated: Bool = true,
         prepare: ((T) -> Void)? = nil,
         completion: ((T) -> Void)? = nil,
         failure: Completion? = nil
     ) {
        guard let pathToCurrent = pathToCurrentController else {
            return
        }

        // Path to previous controller
        let pathToTarget: [Trace] = pathToCurrent.dropLast()

        let jumpTraces = Route(
            pathToVisible: pathToCurrent,
            pathToTarget: pathToTarget
        )

        perform(
            jumpRoute: jumpTraces,
            animated: animated,
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
        guard let pathToCurrent = pathToCurrentController else {
            return
        }

        // Path to first content controller
        var pathToTarget: [Trace] = []

        for trace in pathToCurrent {

            pathToTarget.append(trace)

            if trace.type.isContent {
                break
            }
        }

        let route = Route(
            pathToVisible: pathToCurrent,
            pathToTarget: pathToTarget
        )

        perform(
            jumpRoute: route,
            animated: animated,
            prepare: prepare,
            completion: completion,
            failure: nil
        )
     }

     public func backToKeyStackRoot<T: UIViewController>(
         animated: Bool = true,
         prepare: ((T) -> Void)? = nil,
         completion: ((T) -> Void)? = nil
     ) {
        guard let target = keyStackContainerController?.root as? T else {
            return
        }

        prepare?(target)

        keyStackContainerController?.backTo(target, animated: animated) {
            completion?(target)
        }
     }

    // MARK: Inplace Navigation

    public func replace(
        to controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        guard let current = keyController else {
            return
        }

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

        } else if findPreviousContentController(for: current) == nil {
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
        guard let pathToTop = pathToTopController else {
            return
        }

        guard let pathToTarget = getPathTo(controller, condition: condition) else {
            return
        }

        let jumpTraces = Route(
            pathToVisible: pathToTop,
            pathToTarget: pathToTarget
        )

        perform(
            jumpRoute: jumpTraces,
            animated: animated,
            prepare: prepare,
            completion: completion,
            failure: failure
        )
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
