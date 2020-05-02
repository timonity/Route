//
//  Navigator.swift
//  Flow
//
//  Created by Nikolai Timonin on 05.04.2020.
//

import UIKit

protocol TransitionsProvider: AnyObject {
    
    var transitions: Set<Transition> { get set }
}

extension TransitionsProvider {
    
    func getTransitionForSource(_ controller: UIViewController) -> Transition? {
        
        return transitions.filter { $0.from === controller }.first
    }
    
    func clear(t: Set<Transition>) {
        
        transitions = transitions.subtracting(t)
    }
    
    func clear() {
        
        let t = transitions.filter { $0.isFinished }
        
        clear(t: t)
        
        print("Transitions count after clear: \(transitions.count)")
    }
}

final class Navigator: NSObject, TransitionsProvider {
    
    // MARK: Private properties
    
    private weak var navigationController: UINavigationController?
    
    internal var transitions: Set<Transition> = []
    
    // MARK: Public properties
    
    var isFinished: Bool {
        
        return navigationController == nil
    }
    
    // MARK: Public methods
    
    init(navigation: UINavigationController) {
        
        self.navigationController = navigation
    }
    
    public func push(
        _ controller: UIViewController,
        from: UIViewController,
        animated: Bool = true,
        animator: Animator? = nil,
        completion: (() -> Void)? = nil
    ) {
        
        guard let navigation = navigationController else {
            
            print("Missing `UINavigationController` for `\(type(of: controller))`")
            
            return
        }
        
        if let animator = animator {
            
            let transition = Transition(from: from, to: controller, animator: animator)
            
            navigation.delegate = transition
            
            transitions.insert(transition)
            
        }
        
        navigation.push(controller: controller, animated: animated, completion: completion)
    }
}

extension Navigator: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        let a = getTransitionForSource(fromVC)?.animator
        
        switch operation {
            
        case .none:
            return nil
            
        case .push:
            
            a?.isOpening = true
            
            return a
            
        case .pop:
            
            a?.isOpening = false
            
            return a
        }
    }
}
