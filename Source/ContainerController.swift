//
//  ContainerController.swift
//  Flow
//
//  Created by Nikolai Timonin on 02.04.2020.
//

import UIKit

// MARK: ContainerController

protocol ContainerController {
    
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

extension ContainerController {

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

// MARK: FlatContainerController

protocol FlatContainerController: ContainerController {

    var controllers: [UIViewController]? { get }

    func selectController(at index: Int)
}

// MARK: StackContainerController

protocol StackContainerController: ContainerController {

    var root: UIViewController? { get }

    func getPreviousController(for controller: UIViewController) -> UIViewController?

    // MARK: Forward Navigation

    func push(
        controller: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    )

    func push(
        controllers: [UIViewController],
        animated: Bool,
        completion: (() -> Void)?
    )

    // MARK: Backward Navigation

    func backTo(
        _ controller: UIViewController,
        animated: Bool,
        completion: Completion?
    )
}
