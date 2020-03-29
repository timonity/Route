//
//  Router.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 13.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

typealias Condition = (UIViewController) -> Bool
typealias Completion = () -> Void

struct BackAction {
    
    var dismiss: UIViewController?
    
    var popTo: UIViewController?
}

struct BackResult {
    
    var target: UIViewController?
    
    var action: BackAction?
}

open class Router {
    
    // MARK: Private properties
    
    public weak var currentController: UIViewController?
    
    // MARK: Public properties
    
    let window: UIWindow
    
    // MARK: - Private methods
    
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
    
    private func findPreviousController(
        for controller: UIViewController
    ) -> BackResult {
        
        return findPreviousController(for: controller) { (c) -> Bool in
            
            if c is UINavigationController {
                
                return false
                
            } else if controller == c {
                
                return false
                
            } else {
                
                return true
            }
        }
    }
    
    private func findPreviousController(
        for controller: UIViewController,
        condition: Condition
    ) -> BackResult {
        
        return findControllerInStack(
            condition: condition,
            current: controller,
            action: BackAction()
        )
    }
    
    private func findControllerInStack(
        condition: Condition,
        current: UIViewController,
        action: BackAction
    ) -> BackResult {
        
        if condition(current) {
            
            return BackResult(target: current, action: action)
            
        } else if let navigation = current.navigationController {
            
            if let prevContr = navigation.findPrevioudController(for: current) {
                
                var newAction = action
                newAction.popTo = prevContr
                
                return findControllerInStack(condition: condition, current: prevContr, action: newAction)
                
            } else {
                
                return findControllerInStack(condition: condition, current: navigation, action: action)
            }
            
        } else if let parent = current.parent {
            
            // Возможно это покрыват кейс, когда парент = табБарКонтроллер
            return findControllerInStack(condition: condition, current: parent, action: action)
        
        } else if let presenting = current.presentingViewController {
            
            var newAction = action
            newAction.dismiss = presenting
            newAction.popTo = nil
            
            // 2. Если презентить из контроллера, который в навигейшн контроллере, то у запрезенченого контроллера
            // presentingViewController будет навигейшн контроллер
            
            if let nav = presenting as? UINavigationController, let top = nav.topViewController {
                
                return findControllerInStack(condition: condition, current: top, action: newAction)
                
            } else if let tabBar = presenting as? UITabBarController {
                
                fatalError("Tabbar in stack not supported")
                
            } else {
             
                return findControllerInStack(condition: condition, current: presenting, action: newAction)
            }
            
        } else {
            
            return BackResult(target: nil, action: nil)
        }
    }
    
    private func navigate(
        with result: BackResult,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        
        if let controllerToDismiss = result.action?.dismiss {
            
            controllerToDismiss.dismiss(animated: animated, completion: completion)
        }
        
        if let controllerToPop = result.action?.popTo {
            
            let isAnimated = (result.action?.dismiss == nil) ? animated : false
            
            controllerToPop.navigationController?.pop(
                to: controllerToPop,
                animated: isAnimated,
                completion: completion
            )
        }
    }
    
    // MARK: - Public methods
    
    public init(window: UIWindow) {
        
        self.window = window
    }
    
    // MARK: Forward
    
    public func setWindowRoot(_ controller: UIViewController, animated: Bool = true) {
        
        if animated == true {
            
            let transition = CATransition()
//            transition.type = CATransitionType.moveIn
//            transition.subtype = CATransitionSubtype.fromTop
            
            window.layer.add(transition, forKey: nil)
        }
        
        window.rootViewController?.dismiss(animated: false, completion: nil)
        window.rootViewController = controller
    }
    
    
    public func push(
        _ controllers: [UIViewController],
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        
        guard let from = currentController else {
            
            print("Current controller not found")
            
            return
        }

        guard let navagation = from.navigationController else {

            print("Missing UINavigationController for \(from)")

            return
        }
        
        navagation.push(controllers: controllers, animated: animated, completion: completion)
    }
    
    public func push(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        
        guard let from = currentController else {
            
            print("Current controller not found")
            
            return
        }
        
        guard let navagation = from.navigationController else {
            
            print("Missing `UINavigationController` for `\(type(of: controller))`")
            
            return
        }
        
        navagation.push(controller: controller, animated: true, completion: completion)
    }
    
    public func present(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        
        guard let from = currentController else {
            
            print("Current controller not found")
            
            return
        }
        
        from.present(controller, animated: animated, completion: completion)
    }
    
    // MARK: Replace
    
    public func replace(
        to controller: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        
        guard let from = currentController else {
            
            print("Current controller not found")
            
            return
        }
        
        if let navigationController = from.navigationController {
            
            if controller.navigationController != nil {
                
                print("Replacing controller in navigation stack with controller in another navigation stack is not supported")
                
                return
            }
            
            navigationController.replace(
                with: controller,
                animated: animated,
                completion: completion
            )
            
        } else if let presenting = from.presentingViewController {
            
            from.dismiss(animated: animated, completion: nil)
            
            presenting.present(controller, animated: animated, completion: completion)
        
        } else if findPreviousController(for: from).target == nil {
            
            setWindowRoot(controller, animated: animated)
        }
    }
    
    // MARK: Back
    
    public func back<T: UIViewController>(
        to: T.Type,
        animated: Bool = true,
        condition: ((T) -> Bool)? = nil,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        
        guard let from = currentController else {
            
            print("Current controller not found")
            
            return
        }
        
        let navigationResult = findPreviousController(for: from) { (controller) -> Bool in
            
            if let c = controller as? T {
                
                if let cond = condition {
                    
                    return cond(c)
                    
                } else {
                    
                    return true
                }
                
            } else {
                
                return false
            }
        }
        
        guard let targetController = navigationResult.target as? T else {
            
            return
        }
        
        prepare?(targetController)
        
        navigate(with: navigationResult, animated: animated) {
            
            completion?(targetController)
        }
    }
    
    public  func exit<T: UIViewController>(
        animated: Bool = true,
        prepare: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        
        guard let from = currentController else {
            
            print("Current controller not found")
            
            return
        }
        
        back(
            to: T.self,
            animated: animated,
            condition: { (controller) -> Bool in
            
                if
                    controller is UINavigationController
                    || controller is UITabBarController
                {
                    
                    return false
                }
                
                return from !== controller
            },
            prepare: prepare,
            completion: completion
        )
    }
}
