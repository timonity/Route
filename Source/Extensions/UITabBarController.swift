//
//  UITabBarController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 28.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

extension UITabBarController: FlatContainerController {

    var controllers: [UIViewController] {
        return viewControllers ?? []
    }

    var visibleController: UIViewController? {
        return selectedViewController
    }

    func selectController(
        at index: Int,
        animated: Bool,
        completion: Completion?
    ) {
        CATransaction.begin()

        CATransaction.setCompletionBlock(completion)
        selectedIndex = index

        CATransaction.commit()
    }

    func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    ) {
        fatalError("Not imlemented")
    }
}
