//
//  UIViewController+Top.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 27.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

protocol TopControllerProvider {
    
    var top: UIViewController? { get }
}

// MARK: TopControllerProvider

extension UINavigationController: TopControllerProvider {
    
    var top: UIViewController? {
        
        return visibleViewController
    }
}

// MARK: TopControllerProvider

extension UITabBarController: TopControllerProvider {
    
    var top: UIViewController? {
        
        return selectedViewController
    }
}
