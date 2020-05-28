//
//  JumpRoute.swift
//  Flow
//
//  Created by Nikolai Timonin on 25.05.2020.
//

import UIKit

struct Route {

    var pathToVisible: [Trace]
    var pathToTarget: [Trace]

    var target: UIViewController? {
        return pathToTarget.last?.controller
    }

    var action: AnimationAction? {
        return getAnimationAction()
    }

    mutating func cutMutualParts() {
        var indicesToRemove: [Int] = []

        for i in 0..<min(pathToVisible.count, pathToTarget.count) - 1 {
            if pathToVisible[i + 1] == pathToTarget[i + 1] {
                indicesToRemove.append(i)
            }
        }

        indicesToRemove.reversed().forEach { (idx) in
            pathToVisible.remove(at: idx)
            pathToTarget.remove(at: idx)
        }
    }

    func getAnimationAction() -> AnimationAction? {
        var action = AnimationAction()

        // Go back animations actions

        traceLoop: for trace in pathToVisible {

            switch trace.openType {

            case .windowRoot, .child, .pushed, .sibling:
                break

            case .presented(let controller):
                action.controllerToDismiss = controller

                break traceLoop
            }
        }

        // Go forward animations actions

        for trace in pathToTarget {

            switch trace.openType {

            case .windowRoot, .presented, .child:
                break

            case .pushed(let container):
                if trace == pathToTarget.last {
                    action.controllerBackTo = (trace.controller, container)
                }

            case .sibling(let container):
                action.controllersToSelect.append((trace.controller, container))
            }
        }

        return action
    }
}
