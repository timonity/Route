//
//  ContainerController.swift
//  Flow
//
//  Created by Nikolai Timonin on 02.04.2020.
//

import UIKit

// MARK: ContainerController

public protocol ContainerController {
    
    // MARK: Required
    
    var visibleController: UIViewController? { get }
    
    // MARK: Optional

    var visibleContentController: UIViewController? { get }

    func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    )
}

public extension ContainerController {

    // MARK: Private

    private func getVisibleContent(
        for controller: UIViewController?
    ) -> UIViewController? {

        if let container = controller as? ContainerController {
            return getVisibleContent(for: container.visibleController)

        } else {
            return controller
        }
    }

    // MARK: - Public

    var visibleContentController: UIViewController? {
        return getVisibleContent(for: visibleController)
    }
}
