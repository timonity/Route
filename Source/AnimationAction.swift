//
//  AnimationAction.swift
//  Flow
//
//  Created by Nikolai Timonin on 24.05.2020.
//

import UIKit

struct AnimationAction {

    // MARK: Public properties

    var controllerToDismiss: UIViewController?
    var controllerBackTo: UIViewController?
    var controllersToSelect: [UIViewController] = []

    // MARK: Public methods

    func perform(
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        var isSelectAnimated = animated
        var isBackToAnimated = animated

        let group = DispatchGroup()

        // Dismiss action

        if let controllerToDismiss =  controllerToDismiss {
            group.enter()

            controllerToDismiss.dismiss(animated: animated) {
                group.leave()
            }

            isSelectAnimated = false
            isBackToAnimated = false
        }

        // Select action

        for controllerToSelect in controllersToSelect {
            group.enter()

            let isLast = controllerToSelect == controllersToSelect.last
            let isAnimated = isLast && isSelectAnimated

            controllerToSelect.flatContainer?.selectController(
                controllerToSelect,
                animated: isAnimated
            ) {
                group.leave()
            }

            isBackToAnimated = false
        }

        // Back action

        if let controllerBackTo = controllerBackTo {
            group.enter()

            controllerBackTo.stackContaier?.backTo(
                controllerBackTo,
                animated: isBackToAnimated
            ) {
                group.leave()
            }
        }

        // Completion

        group.notify(queue: DispatchQueue.main) {
            completion?()
        }
    }
}
