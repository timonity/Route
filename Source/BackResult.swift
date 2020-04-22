//
//  BackResult.swift
//  Flow
//
//  Created by Nikolai Timonin on 01.04.2020.
//

import UIKit

public struct BackAction {
    
    public var dismiss: UIViewController?
    
    public var popTo: UIViewController?
}

struct BackResult {
    
    var action: BackAction
    
    var target: UIViewController?
    
    var lastContentController: UIViewController?
    
    var stack: [UIViewController] = []
}
