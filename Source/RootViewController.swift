//
//  RootViewController.swift
//  Flow
//
//  Created by Nikolai Timonin on 02.04.2020.
//

import UIKit

class RootViewController: UIViewController {
    
    // MARK: Override properties
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        
        return current
    }
    
    override var childViewControllerForStatusBarHidden: UIViewController? {
        
        return current
    }
    
    // MARK: Public properties
    
    public var current: UIViewController? {
        
        return childViewControllers.first
    }
    
    // MARK: Public methods
    
    func insert(_ controller: UIViewController) {
        
        addChildViewController(controller)
        
        controller.view.frame = view.frame
        
        view.addSubview(controller.view)
        
        controller.didMove(toParentViewController: self)   
    }
    
    func transition(
        from: UIViewController,
        to: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        
        from.willMove(toParentViewController: nil)
        addChildViewController(to)
        
        view.addSubview(to.view)
        
        to.view.frame = CGRect(
            x: 0,
            y: from.view.frame.height,
            width: from.view.frame.width,
            height: from.view.frame.height
        )
        
        let isDismissNeeded = from.presentedViewController != nil
        
        let duration = (animated && !isDismissNeeded) ? 0.25 : 0
        
        UIView.animate(
            withDuration: duration,
            animations: {
            
                to.view.frame = from.view.frame
            },
            completion: { _ in
            
                if isDismissNeeded {
                    
                    from.dismiss(animated: animated) {
                        
                        completion?()
                    }
                }
                
                from.removeFromParentViewController()
                to.didMove(toParentViewController: self)
                
                if isDismissNeeded == false {
                    
                    completion?()
                }
        })
    }
}

// MARK: ContainerController

extension RootViewController: ContainerController {
    
    var visibleController: UIViewController? {
        
        return current
    }
    
    func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    ) {
        transition(
            from: controller,
            to: newController,
            animated: animated,
            completion: completion
        )
    }
}
