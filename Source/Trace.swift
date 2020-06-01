//
//  Trace.swift
//  Route
//
//  Created by Nikolai Timonin on 12.05.2020.
//

import UIKit

struct Trace {

    // MARK: Types

    enum ControllerType {

        case content
        case container
        case flatContainer
        case stackContaier

        var isContent: Bool {
            return self == .content
        }
    }

    enum OpenType {

        case windowRoot
        case presented(UIViewController)
        case child(ContainerController)
        case pushed(StackContainerController)
        case sibling(FlatContainerController)
    }

    // MARK: Public properties

    let controller: UIViewController
    let openType: OpenType
    let isOnTopWay: Bool

    var type: ControllerType {
        if controller is StackContainerController {
            return .stackContaier

        } else if controller is FlatContainerController {
            return .flatContainer

        } else if controller is ContainerController {
            return .container

        } else {
            return .content
        }
    }
}

// MARK: Equatable

extension Trace: Equatable {

    public static func == (lhs: Trace, rhs: Trace) -> Bool {
        return lhs.controller == rhs.controller
    }
}
