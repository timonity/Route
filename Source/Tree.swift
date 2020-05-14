//
//  Tree.swift
//  Flow
//
//  Created by Nikolai Timonin on 12.05.2020.
//

import Foundation

public class Node<T> {

    // MARK: Public properties

    let value: T

    var children: [Node<T>] = []

    var parent: Node<T>?

    // MARK: Public methods

    init(value: T) {
        self.value = value
    }

    func addChild(_ node: Node<T>) {
        children.append(node)
        node.parent = self
    }
}

public extension Node {

    func search(condition: (T) -> Bool) -> Node? {

        if condition(value) {
            return self

        } else {
            for child in children {
                if let result = child.search(condition: condition) {
                    return result
                }
            }

            return nil
        }
    }

    func map<P>(_ transform: (T) throws -> P) rethrows -> Node<P> {
        let newValue = try transform(value)

        let result = Node<P>(value: newValue)

        for child in children {
            let newChild = try child.map(transform)
            result.addChild(newChild)
        }

        return result
    }
}


public extension Node where T: Equatable {

    func search(value: T) -> Node? {
        return search { $0 == value }
    }
}

// MARK: CustomStringConvertible

extension Node: CustomStringConvertible {

    public var description: String {

        var result = "{\(value)"

        for child in children {

            result += child.description
        }

        result += "}"

        return result
    }

}
