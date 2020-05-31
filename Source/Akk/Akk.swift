//
//  Akk.swift
//  RouteExample
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
