//
//  FlowExampleUITests.swift
//  FlowExampleUITests
//
//  Created by Nikolai Timonin on 04.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import XCTest
import FlowExample

class FlowExampleUITests: XCTestCase {

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
        tapButton(for: action)
        navigationTree.performAction(action)

        check()
    }

    func check(isVerbose: Bool = true) {
        let tree = getTreeLabel(with: navigationTree.id).label
        let plot = navigationTree.plot().0

        if isVerbose {
            print(tree)
            print(navigationTree.plot().0)
        }

        XCTAssertEqual(tree, plot)
    }

    func tapButton(for action: Action) {

        getButton(for: action).tap()
    }

    func getButton(for action: Action) -> XCUIElement {

        let id = navigationTree.id

        return app.buttons["\(id)-\(action.title)"]
    }

    func getTreeLabel() -> XCUIElement {

        return getTreeLabel(with: navigationTree.id)
    }

    func getTreeLabel(with id: Int) -> XCUIElement {

        return app.staticTexts["\(id)-Tree"]
    }

    // MARK: Tests

    func testBack() {
        let actions: [Action] = [
            .present,
            .push,
            .push,
            .backToNavigationRoot,
            .present,
            .back,
            .backToWindowRoot,
            .present,
            .present,
            .push,
            .push,
            .backTo(3)
        ]

        perform(actions)
    }
}
