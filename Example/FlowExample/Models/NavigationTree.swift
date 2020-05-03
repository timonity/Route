//
//  NavigationTree.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 03.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Foundation

struct NavigationTree {

    // MARK: Public properties

    static var root: NavigationTree {

        return NavigationTree(id: 0, levels: ["->[0]"])
    }

    var id: Int

    var levels: [String]

    // MARK: Private methdos

    func getControllerIcon(with id: Int) -> String {

        return "[\(id)]"
    }

    // MARK: Public methods

    mutating func growWithPush() {

        guard var lastLevel = levels.last else { return }

        id += 1

        lastLevel.append("––")
        lastLevel.append(getControllerIcon(with: id))

        levels[levels.count - 1] = lastLevel
    }

    mutating func growWithPresent() {

        guard let lastLevel = levels.last else { return }

        id += 1

        let lastLength = lastLevel.count - 1

        levels.append(
            " ".duplicate(lastLength - 1) + "|"
        )

        levels.append(
            " ".duplicate(lastLength - 2) + getControllerIcon(with: id)
        )
    }

    mutating func growWithReplace() {

        guard var lastLevel = levels.last else { return }

        id += 1

        let offset = -2 - String(id).count

        let leftBound = lastLevel.index(lastLevel.endIndex, offsetBy: offset)
        let rightBound = lastLevel.index(lastLevel.endIndex, offsetBy: 0)

        lastLevel.replaceSubrange(leftBound..<rightBound, with: getControllerIcon(with: id))

        levels[levels.count - 1] = lastLevel
    }

    func plot() -> (String, Int) {

        let tree = levels
            .reversed()
            .map { $0.appending("\n") }
            .reduce("") { $0 + $1 }

        return (tree, levels.count + 1)
    }
}
