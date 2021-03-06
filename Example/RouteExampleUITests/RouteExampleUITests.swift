//
//  RouteExampleUITests.swift
//  RouteExampleUITests
//
//  Created by Nikolai Timonin on 04.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import XCTest
import RouteExample

class RouteExampleUITests: XCTestCase {

    // MARK: Public properties

    var app: XCUIApplication!

    var navigationTree: NavigationTree!

    // MARK: Override methods

    override func setUpWithError() throws {
        continueAfterFailure = false

        navigationTree = NavigationTree.root

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: Public methods

    func perform(_ actions: [Action]) {
        actions.forEach { perform($0) }
    }

    func perform(_ action: Action) {
        tapElement(for: action)
        navigationTree.performAction(action)

        sleepIfNeeded(for: action)

        check()
    }

    func sleepIfNeeded(for action: Action) {
        if action == .setWindowRoot {
            sleep(1)
        }
    }

    func check(isVerbose: Bool = true) {
        var tree = getTreeLabel(with: navigationTree.id).label
        var plot = navigationTree.plot().0

        tree = tree.replacingOccurrences(of: " ", with: "")
        tree = tree.replacingOccurrences(of: "\n", with: "")

        plot = plot.replacingOccurrences(of: " ", with: "")
        plot = plot.replacingOccurrences(of: "\n", with: "")

        if isVerbose {
            print(tree)
            print(plot)
        }

        XCTAssertEqual(tree, plot)
    }

    func tapElement(for action: Action) {
        getElement(for: action).tap()
    }

    func getElement(for action: Action) -> XCUIElement {
        let id = navigationTree.id

        return app.cells["\(id)-\(action.title)"]
    }

    func getTreeLabel() -> XCUIElement {
        return getTreeLabel(with: navigationTree.id)
    }

    func getTreeLabel(with id: Int) -> XCUIElement {
        return app.staticTexts["\(id)-Tree"]
    }

    // MARK: Tests

    func testReplace() {
        let actions: [Action] = [
            .replace,
            .push,
            .replace,
            .present,
            .replace
        ]

        perform(actions)
    }

    func testBack() {
        let actions: [Action] = [
            .push,
            .back,
            .present,
            .present,
            .back
        ]

        perform(actions)
    }

    func testBackTo() {
        let actions: [Action] = [
            .push,
            .push,
            .push,
            .push,
            .present,
            .push,
            .backTo(3)
        ]

        perform(actions)
    }

    func testWindowRoot() {
        let actions: [Action] = [
            .push,
            .present,
            .setWindowRoot,
            .present,
            .push,
            .backToWindowRoot
        ]

        perform(actions)
    }

    func testToNavigationRoot() {
        let actions: [Action] = [
            .present,
            .push,
            .backToNavigationRoot
        ]

        perform(actions)
    }

    func testRandom() {
        let actions: [Action] = [
            .present,
            .push,
            .push,
            .backToNavigationRoot,
            .present,
            .replace,
            .back,
            .backToWindowRoot,
            .present,
            .present,
            .push,
            .push,
            .push,
            .backToNavigationRoot,
            .replace,
            .backTo(3),
            .replace,
            .setWindowRoot,
            .replace
        ]

        perform(actions)
    }
}
