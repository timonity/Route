//
//  Tree.swift
//  Route
//
//  Created by Nikolai Timonin on 12.05.2020.
//

import Foundation

class Node<T> {

    // MARK: Public properties

    let value: T

    var children: [Node<T>] = []

    weak var parent: Node<T>?

    var isLeaf: Bool {
        return children.isEmpty
    }

    var isRoot: Bool {
        return parent == nil
    }

    // MARK: Public methods

    init(value: T) {
        self.value = value
    }

    func addChild(_ node: Node<T>) {
        children.append(node)
        node.parent = self
    }

    func removeChilds() {
        children.removeAll()
    }
}

// MARK: Search & Map

extension Node {

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
}

extension Node where T: Equatable {

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

// MARK: Equatable

extension Node: Equatable where T: Equatable {

    static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: Find Path

extension Node {

    public func findPath(
        condition: (T) -> Bool
    ) -> [T]? {

        guard isRoot else {
            Logger.critical("Try to find path not from root node \(self)")

            return nil
        }

        var result = [value]

        var isSuccess = false

        findPath(
            condition: condition,
            node: self,
            result: &result,
            isSuccess: &isSuccess
        )

        if isSuccess {
            return result

        } else {
            return nil
        }
    }

    private func findPath(
        condition: (T) -> Bool,
        node: Node<T>,
        result: inout [T],
        isSuccess: inout Bool
    ) {
        if condition(node.value) {
            isSuccess = true

            return
        }

        for child in node.children {
            var isSuccessForChild = false

            result.append(child.value)

            findPath(
                condition: condition,
                node: child,
                result: &result,
                isSuccess: &isSuccessForChild
            )

            if isSuccessForChild {
                isSuccess = true
                break

            } else {
                result.removeLast()
            }
        }
    }
}
