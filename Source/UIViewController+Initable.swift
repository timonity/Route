//
//  UIViewController+Initable.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 11.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

// MARK: Initable

public protocol Initable {
    
    static func initiate() -> Self
}

// MARK: StoryboadInitable

public protocol StoryboadInitable: Initable {
    
    static var storyboardName: String { get }
    
    static var storyboardId: String { get }
}

public extension StoryboadInitable where Self: UIViewController {
    
    static var storyboardId: String {
        
        return String(describing: self)
    }
    
    static func initiate() -> Self {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        guard let instance = storyboard.instantiateViewController(withIdentifier: storyboardId) as? Self else {
            
            fatalError("Unable to initiate `\(self)` with storyboard id `\(storyboardId)` from storyboard `\(storyboardName)`")
        }
        
        return instance
    }
}

// MARK: XibInitable

public protocol XibInitable: Initable {
    
    static var xibName: String { get }
}

public extension XibInitable where Self: UIViewController {
    
    static var xibName: String {
        
        return String(describing: self)
    }
    
    static func initiate() -> Self {
        
        return Self(nibName: xibName, bundle: nil)
    }
}
