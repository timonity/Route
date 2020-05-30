//
//  PageViewController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 30.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Flow

class PageViewController: UIPageViewController {

    // MARK: Private properties

    private var selectedController: UIViewController?

    // MARK: Public properties

    var childControllers: [UIViewController] = [] {
        didSet {
            setController(
                at: 0,
                animated: false,
                completion: nil
            )
        }
    }

    var didSelectControllerHandler: ((Int) -> Void)?

    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
    }

    // MARK: Private methods

    private func setController(
        at index: Int,
        animated: Bool,
        completion: Completion?
    ) {
        let controller = childControllers[index]

        selectedController = controller

        didSelectControllerHandler?(index)

        setViewControllers(
            [controller],
            direction: .reverse,
            animated: animated,
            completion: { _ in completion?() }
        )
    }
}

// MARK: FlatContainerController

extension PageViewController: FlatContainerController {

    public var controllers: [UIViewController] {
        return childControllers
    }

    public var visibleController: UIViewController? {
        return selectedController
    }

    public func replace(
        _ controller: UIViewController,
        with newController: UIViewController,
        animated: Bool,
        completion: Completion?
    ) {
        assertionFailure("Not implemented")
    }

    public func selectController(
        at index: Int,
        animated: Bool,
        completion: Completion?
    ) {
        setController(
            at: index,
            animated: animated,
            completion: completion
        )
    }
}

// MARK: UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let idx = controllers.firstIndex(of: viewController) else {
            return nil
        }

        return controllers[safe: idx - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let idx = controllers.firstIndex(of: viewController) else {
            return nil
        }

        return controllers[safe: idx + 1]
    }
}

// MARK: UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let idx = controllers.firstIndex(of: pageViewController.children[0]) else {
            return
        }

        selectedController = controllers[idx]

        didSelectControllerHandler?(idx)
    }
}
