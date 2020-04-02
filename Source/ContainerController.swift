//
//  ContainerController.swift
//  Flow
//
//  Created by Nikolai Timonin on 02.04.2020.
//

import UIKit

protocol ContainerController {
    
    var visibleController: UIViewController? { get }
}


extension UINavigationController: ContainerController {
    
    var visibleController: UIViewController? {
        
        return topViewController
    }
}

extension UITabBarController: ContainerController {
    
    var visibleController: UIViewController? {
        
        if let container = selectedViewController as? ContainerController {
            
            return container.visibleController
            
        } else {
            
            return selectedViewController
        }
    }
}

extension RootViewController: ContainerController {
    
    var visibleController: UIViewController? {
        
        return current
    }
}
