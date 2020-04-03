//
//  UIViewController.swift
//  Flow
//
//  Created by Nikolai Timonin on 02.04.2020.
//

import UIKit

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
