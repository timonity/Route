//
//  Transition.swift
//  Flow
//
//  Created by Nikolai Timonin on 04.04.2020.
//

import UIKit

final class Transition: NSObject {
    
    // MARK: Public properties
    
    weak var from: UIViewController?
    weak var to: UIViewController?
    
    let animator: Animator
    
    var isFinished: Bool {
        
        return to == nil
    }
    
    // MARK: Public methods
    
    init(from: UIViewController, to: UIViewController, animator: Animator) {
        
        self.from = from
        self.to = to
        
        self.animator = animator
    }
}

// MARK: UINavigationControllerDelegate

//extension Transition: UINavigationControllerDelegate {
//
//    func navigationController(
//        _ navigationController: UINavigationController,
//        animationControllerFor operation: UINavigationControllerOperation,
//        from fromVC: UIViewController,
//        to toVC: UIViewController
//    ) -> UIViewControllerAnimatedTransitioning? {
//
//        switch operation {
//
//        case .none:
//            return nil
//
//        case .push:
//            animator.isOpening = true
//
//            return animator
//
//        case .pop:
//            animator.isOpening = false
//
//            return animator
//        }
//    }
//}

// MARK: UIViewControllerTransitioningDelegate

//extension Transition: UIViewControllerTransitioningDelegate {
//
//    func animationController(
//        forPresented presented: UIViewController,
//        presenting: UIViewController,
//        source: UIViewController
//    ) -> UIViewControllerAnimatedTransitioning? {
//
//        animator.isOpening = true
//
//        return animator
//    }
//
//    func animationController(
//        forDismissed dismissed: UIViewController
//    ) -> UIViewControllerAnimatedTransitioning? {
//
//        animator.isOpening = false
//
//        return animator
//    }
//}
