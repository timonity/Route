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
    
    func transition(from: UIViewController, to: UIViewController, completion: Completion? = nil) {
        
        from.willMove(toParentViewController: nil)
        self.addChildViewController(to)
        
        transition(
            from: from,
            to: to,
            duration: transitionCoordinator?.transitionDuration ?? 0.4,
            options: [.transitionFlipFromTop],
            animations: { },
            completion: { (finished) in
                
                from.removeFromParentViewController()
                to.didMove(toParentViewController: self)
                
                completion?()
            }
        )
    }
}

// MARK: ContainerController

extension RootViewController: ContainerController {
    
    var visibleController: UIViewController? {
        
        return current
    }
}
