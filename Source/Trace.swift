//
//  Trace.swift
//  Flow
//
//  Created by Nikolai Timonin on 12.05.2020.
//

import UIKit

enum OpenType {

    case windowRoot
    case presented(UIViewController)
    case child(ContainerController)
    case pushed(StackContainerController)
    case sibling(FlatContainerController)
}

enum Type {

    case undefind
    case content
    case container
    case flatContainer
    case stackContaier
}

public struct Trace {

    public let controller: UIViewController
    let openType: OpenType
    let isOnTopWay: Bool

    var type: Type {
        fatalError("Implement base on protocol conformance")
    }
}

// MARK: Equatable

extension Trace: Equatable {

    public static func == (lhs: Trace, rhs: Trace) -> Bool {
        return lhs.controller == rhs.controller
    }
}

// MARK: To Action

extension Trace {

    var action: Action? {

        switch openType {

        case .windowRoot:
            return nil

        case .presented(let presented):
            return .dismiss(controller)

        case .child(let container):
            return nil

        case .pushed(let stackContainer):
            return .popTo(controller)

        case .sibling(let flatContainer):
            return .select(controller)

        }
    }
}
