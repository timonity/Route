//
//  AnimationAction.swift
//  Route
//
//  Created by Nikolai Timonin on 24.05.2020.
//

import UIKit

struct AnimationAction {

    // MARK: Public properties

    var controllerToDismiss: UIViewController?
    var controllerBackTo: (UIViewController, StackContainerController)?
    var controllersToSelect: [(UIViewController, FlatContainerController)] = []

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

            let isLast = controllerToSelect.0 == controllersToSelect.last?.0
            let isAnimated = isLast && isSelectAnimated

            controllerToSelect.1.selectController(
                controllerToSelect.0,
                animated: isAnimated
            ) {
                group.leave()
            }

            isBackToAnimated = false
        }

        // Back action

        if let controllerBackTo = controllerBackTo {
            group.enter()

            controllerBackTo.1.backTo(
                controllerBackTo.0,
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
