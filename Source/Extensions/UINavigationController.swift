//
//  UINavigationController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 28.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

extension UINavigationController: StackContainerController {

    var visibleController: UIViewController? {
        
        return topViewController
    }

    var controllers: [UIViewController] {

        return viewControllers
    }

    var root: UIViewController? {

        return viewControllers.first
    }
    
    func getPreviousController(
        for controller: UIViewController
    ) -> UIViewController? {
        
        let controllers: [UIViewController] = viewControllers.reversed()
        
        for i in 0..<controllers.count {
            
            if controllers[i] === controller && i < controllers.count - 1 {
                
                return controllers[i + 1]
            }
        }
        
        return nil
    }

    // MARK: Forward Navigation

    func push(
        controller: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {

        CATransaction.begin()

        CATransaction.setCompletionBlock(completion)
        pushViewController(controller, animated: animated)

        CATransaction.commit()
    }

    func push(
        controllers: [UIViewController],
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()

        CATransaction.setCompletionBlock(completion)
        setViewControllers(controllers, animated: animated)

        CATransaction.commit()
    }

    // MARK: Inplace Navigation

    func replace(
        _ oldController: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    ) {
        guard let oldIdx = viewControllers.firstIndex(of: oldController) else {
            print("Controller `\(oldController)` not found in navigation controller `\(self)` stack")
            return
        }

        var controllers = viewControllers
        controllers[oldIdx] = newController

        push(
            controllers: controllers,
            animated: animated,
            completion: completion
        )
    }

    // MARK: Backward Navigation
    
    func backTo(
        _ controller: UIViewController,
        animated: Bool,
        completion: Completion?
    ) {
        CATransaction.begin()

        CATransaction.setCompletionBlock(completion)
        popToViewController(controller, animated: animated)

        CATransaction.commit()
    }
}
