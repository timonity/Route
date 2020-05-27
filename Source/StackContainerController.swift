//
//  StackContainerController.swift
//  Flow
//
//  Created by Nikolai Timonin on 27.05.2020.
//

import UIKit

protocol StackContainerController: ContainerController {

    var controllers: [UIViewController] { get }

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
