//
//  PageViewController.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 30.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Route

class PageViewController: UIPageViewController {

    // MARK: Private properties

    private var selectedController: UIViewController?

    private var selectPretender: UIViewController?

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

        let pageControl = UIPageControl.appearance(
            whenContainedInInstancesOf: [PageViewController.self]
        )
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black

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
            direction: .forward,
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
        guard let idx = childControllers.firstIndex(of: viewController) else {
            return nil
        }

        return childControllers[safe: idx - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let idx = childControllers.firstIndex(of: viewController) else {
            return nil
        }

        return childControllers[safe: idx + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return childControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard
            let pretender = selectedController,
            let idx = childControllers.firstIndex(of: pretender)
        else {
            return 0
        }

        return idx
    }
}

// MARK: UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        selectPretender = pendingViewControllers.first
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed else { return }

        guard
            let pretender = selectPretender,
            let idx = childControllers.firstIndex(of: pretender)
        else {
            return
        }

        selectedController = childControllers[idx]

        didSelectControllerHandler?(idx)
    }
}
