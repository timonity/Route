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

    var root: UIViewController? { get }
    
    var visibleContentController: UIViewController? { get }
    
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

    // MARK: Inplace Navigation

    func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    )

    // MARK: Backward Navigation

    func backTo(
        _ controller: UIViewController,
        animated: Bool,
        completion: Completion?
    )
}

// MARK: Default Implementation

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

    var root: UIViewController? {
        return nil
    }
    
    func getPreviousController(
        for controller: UIViewController
    ) -> UIViewController? {
        return nil
    }

    // MARK: Forward Navigation

    func push(
        controller: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) { }

    func push(
        controllers: [UIViewController],
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) { }

    // MARK: Inplace Navigation

    func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    ) { }

    // MARK: Backward Navigation

    func backTo(
        _ controller: UIViewController,
        animated: Bool,
        completion: Completion?
    ) { }
}
