//
//  UITabBarController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 28.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

extension UITabBarController: TopControllerProvider {
    
    var top: UIViewController? {
        
        return selectedViewController
    }
}
