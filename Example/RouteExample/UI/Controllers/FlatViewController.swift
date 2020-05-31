//
//  FlatController.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 28.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Route

class FlatViewController: UIViewController {

    // MARK: Private properties

    @IBOutlet private weak var titleLabel: UILabel!

    private var pageController: PageViewController? {
        return children.first as? PageViewController
    }

    // MARK: Public properties

    var selectedController: UIViewController?

    var controllers: [ViewController] = {
        let c1 = ViewController.initiate()
        c1.navigationTree = NavigationTree(levels: [[1]])
        c1.view.backgroundColor = .red

        let c2 = ViewController.initiate()
        c2.navigationTree = NavigationTree(levels: [[2]])
        c2.view.backgroundColor = .green

        let c3 = ViewController.initiate()
        c3.navigationTree = NavigationTree(levels: [[3]])
        c3.view.backgroundColor = .purple

        return [c1, c2, c3]
    }()

    // MARK: Override methods

    override func awakeFromNib() {
        super.awakeFromNib()

        // Load view on awakining to force setup page view controller.
        // It needs to add controllers to navigation tree.
        load()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pageController?.childControllers = controllers

        updateUI(index: 0)

        pageController?.didSelectControllerHandler = { [weak self] idx in
            self?.updateUI(index: idx)
        }
    }

    // MARK: Private methods

    private func updateUI(index: Int) {
        titleLabel.text = String(controllers[index].id)
    }

    private func load() {
        _ = view
    }
}

// MARK: ContainerController

extension FlatViewController: ContainerController {

    var visibleController: UIViewController? {
        return pageController
    }

    func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    ) {
        assertionFailure("Not implemented")
    }
}

// MARK: StoryboadInitable

extension FlatViewController: StoryboadInitable {

    static var storyboardName: String {
        return "Main"
    }
}
