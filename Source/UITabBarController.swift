//
//  UITabBarController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 28.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

// MARK: ContainerController

extension UITabBarController: ContainerController {
    
    var visibleController: UIViewController? {
        
        if let container = selectedViewController as? ContainerController {
            
            return container.visibleController
            
        } else {
            
            return selectedViewController
        }
    }
}
