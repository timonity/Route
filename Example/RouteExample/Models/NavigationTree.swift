//
//  NavigationTree.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 03.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Foundation

struct NavigationTree: Hashable {

    // MARK: Public properties

    static var root: NavigationTree {
        return NavigationTree(levels: [[0]])
    }

    var id: Int {
        return stackIds.last ?? 0
    }

    var nextId: Int {
        return id + 1
    }

    var previousId: Int? {
        return stackIds[stackIds.count - 2]
    }

    var stackIds: [Int] {
        return levels.flatMap { $0 }
    }

    var levels: [[Int]] = []

    // MARK: Private methdos

    private func getControllerIcon(with id: Int) -> String {
        return "[\(id)]"
    }

    // MARK: - Public methods

    // MARK: Forward Navigation

    mutating func push() {
        levels[levels.count - 1].append(nextId)
    }

    mutating func present() {
        levels.append([nextId])
    }

    // MARK: Inplace Navigation

    mutating func replace() {
        let newId = nextId

        levels[levels.count - 1].removeLast()
        levels[levels.count - 1].append(newId)
    }

    mutating func setWindowRoot() {
        levels = [[0]]
    }

    // MARK: Backward Navigation

    mutating func back() {
        guard let prev = previousId else {
            print("Previous id not found for id: \(id)")
            return
        }

        backTo(prev)
    }

    mutating func backToRoot() {
        backTo(stackIds[0])
    }

    mutating func backToKeyLevelRoot() {
        backTo(levels[levels.count - 1][0])
    }

    mutating func backTo(_ id: Int) {

        for levelIdx in (0..<levels.count).reversed() {

            let level = levels[levelIdx]

            if level.contains(id) == false {
                levels.remove(at: levelIdx)

            } else {
                levels[levelIdx].removeAll { $0 > id }
                break
            }
        }
    }

    func plot() -> (String, Int) {

        var lvls: [String] = []

        for level in levels {

            var lvl = ""

            if let count = lvls.last?.count {

                lvls.append(
                    " ".duplicate(count - 2) + "↑"
                )

                lvl.append(
                    " ".duplicate(count - 3)
                )
            }

            for id in level {

                lvl.append(getControllerIcon(with: id))

                if id == level.last { break }

                lvl.append("→")
            }

            lvls.append(lvl)
        }

        let tree = lvls
            .reversed()
            .map { $0.appending("\n") }
            .reduce("") { $0 + $1 }
            .dropLast()

        return (String(tree), lvls.count + 1)
    }
}

extension NavigationTree {

    mutating func performAction(_ action: Action) {
        switch action {

        case .push:
            push()

        case .present:
            present()

        case .replace:
            replace()

        case .setWindowRoot:
            setWindowRoot()

        case .jumpTo:
            fatalError("Jump not implemented")

        case .back:
            back()

        case .backTo(let id):
            backTo(id)

        case .backToWindowRoot:
            backToRoot()

        case .backToNavigationRoot:
            backToKeyLevelRoot()
        }
    }
}
