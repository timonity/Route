//
//  ContainerController.swift
//  Flow
//
//  Created by Nikolai Timonin on 02.04.2020.
//

import UIKit

protocol ContainerController {
    
    // MARK: Required
    
    var visibleController: UIViewController? { get }
    
    // MARK: Optional
    
    var visibleContentController: UIViewController? { get }
    
    func getPreviousController(for controller: UIViewController) -> UIViewController?
    
    func backTo(_ controller: UIViewController, animated: Bool, completion: Completion?)
    
    func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    )
}

// MARK: Default Implementation

extension ContainerController {
    
    // MARK: Public
    
    var visibleContentController: UIViewController? {
        
        return getVisibleContent(for: visibleController)
    }
    
    func getPreviousController(for controller: UIViewController) -> UIViewController? {
        
        return nil
    }
    
    func backTo(_ controller: UIViewController, animated: Bool, completion: Completion?) { }
    
    func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    ) { }
    
    // MARK: Private
    
    private func getVisibleContent(for controller: UIViewController?) -> UIViewController? {
        
        if let container = controller as? ContainerController {
            
            return getVisibleContent(for: container.visibleController)
            
        } else {
            
            return controller
        }
    }
}
