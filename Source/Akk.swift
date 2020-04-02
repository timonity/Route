//
//  Akk.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 13.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

// MARK: Prepare for unwind

//protocol AnyUnwind {
//    
//    func handleAny(item: Any)
//}

protocol Unwind {
    
    associatedtype ItemType
    
    func handle(item: ItemType)
}

//extension Unwind {
//    
//    func handleAny(item: Any) {
//        
//        handle(item: item as! ItemType)
//    }
//}


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

extension UIViewController {
    
    func removeChild(_ controller: UIViewController) {
        
        controller.willMove(toParentViewController: nil)
        
        controller.view.removeFromSuperview()
        
        controller.removeFromParentViewController()
    }
    
    func insert(controller instantiate: UIViewController, into insertTargetView: UIView? = nil) {
        
        addChildViewController(instantiate)
        
        (insertTargetView ?? view).addSubview(instantiate.view)
        
        instantiate.view.appendConstraints(to: insertTargetView ?? view)
        
        instantiate.didMove(toParentViewController: self)
    }
    
}

extension UIView {
    
    func appendConstraints(to view: UIView, withSafeArea isWithSafeArea: Bool = false) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if isWithSafeArea, #available(iOS 11.0, *) {
            
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
        } else {
            
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
    }
}
