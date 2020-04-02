//
//  BackResult.swift
//  Flow
//
//  Created by Nikolai Timonin on 01.04.2020.
//

import UIKit

struct BackAction {
    
    var dismiss: UIViewController?
    
    var popTo: UIViewController?
}

struct BackResult {
    
    var target: UIViewController?
    
    var action: BackAction?
}
