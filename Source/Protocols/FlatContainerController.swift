//
//  File.swift
//  Route
//
//  Created by Nikolai Timonin on 27.05.2020.
//

import UIKit

public protocol FlatContainerController: ContainerController {

    var controllers: [UIViewController] { get }

    func selectController(
        at index: Int,
        animated: Bool,
        completion: Completion?
    )
}

public extension FlatContainerController {

    func selectController(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        guard let index = controllers.firstIndex(of: controller) else {
            Logger.error("Couldn't select \(controller) in \(self). Controller index not found.")

            return
        }

        selectController(
            at: index,
            animated: animated,
            completion: completion
        )
    }

}

