//
//  UIViewController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 31.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Flow

extension UIViewController {

    var router: Router {
        return Router(window: UIApplication.shared.keyWindow, controller: self)
    }
}
