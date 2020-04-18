//
//  ContainerController.swift
//  Flow
//
//  Created by Nikolai Timonin on 02.04.2020.
//

import UIKit

protocol ContainerController {
    
    var visibleController: UIViewController? { get }
    
    var visibleContentController: UIViewController? { get }
}


extension ContainerController {
    
    var visibleContentController: UIViewController? {
        
        return getVisibleContent(for: visibleController)
    }
    
    
    private func getVisibleContent(for controller: UIViewController?) -> UIViewController? {
        
        if let container = controller as? ContainerController {
            
            return getVisibleContent(for: container.visibleController)
            
        } else {
            
            return controller
        }
    }
    
    
}
