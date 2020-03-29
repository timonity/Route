//
//  UINavigationController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 28.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

extension UINavigationController: TopControllerProvider {
    
    var top: UIViewController? {
        
        return visibleViewController
    }
}

extension UINavigationController {
    
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
    
    func pop(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        
        CATransaction.commit()
    }
    
    func pop(
        to controller: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock(completion)
        popToViewController(controller, animated: animated)
        
        CATransaction.commit()
    }
    
    func replace(
        with controller: UIViewController,
        animated: Bool,
        completion: Completion? = nil
    ) {
        var controllers = viewControllers
        controllers[controllers.count - 1] = controller

        push(
            controllers: controllers,
            animated: animated,
            completion: completion
        )
    }
}

extension UINavigationController {
    
    func findPrevioudController(
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
}
