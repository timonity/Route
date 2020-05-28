//
//  FlatController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 28.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Flow

class MyViewController: UIViewController, CodeInitable {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
}

class My2ViewController: UIViewController, CodeInitable {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
}

class FlatViewController: UIViewController {

    // MARK: Override properties

    // MARK: Private properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pageControl: UIPageControl!

    private var pageController: UIPageViewController? {
        return children.first as? UIPageViewController
    }

    // MARK: Public properties

    var selectedController: UIViewController?

    var controllers: [UIViewController] = {

        let first = MyViewController.initiate()

        let second = MyViewController.initiate()

        let thrird = My2ViewController.initiate()

        return [first, thrird]
    }()

    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        pageController?.dataSource = self
        pageController?.delegate = self

        pageControl.numberOfPages = controllers.count

        updateUI(index: 0)

        pageController?.setViewControllers(
            [controllers[0]],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }

    // MARK: Private methods

    private func updateUI(index: Int) {
        titleLabel.text = "Selected controller: \(index)"

        pageControl.currentPage = index
    }

    // MARK: Public methods

    func selectController(
        at index: Int,
        animated: Bool,
        completion: Completion?
    ) {
        updateUI(index: index)

        pageController?.setViewControllers(
            [controllers[index]],
            direction: .reverse,
            animated: animated,
            completion: { _ in completion?() }
        )
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

// MARK: UIPageViewControllerDataSource

extension FlatViewController: UIPageViewControllerDataSource {

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

extension FlatViewController: UIPageViewControllerDelegate {

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

        updateUI(index: idx)
    }
}

// MARK: StoryboadInitable

extension FlatViewController: StoryboadInitable {

    static var storyboardName: String {
        return "Main"
    }
}

// MARK: UIPageViewController

extension UIPageViewController {

    var flatController: FlatViewController? {
        return parent as? FlatViewController
    }
}

extension UIPageViewController: FlatContainerController {

    public var controllers: [UIViewController] {
        return flatController?.controllers ?? []
    }

    public var visibleController: UIViewController? {
        return flatController?.selectedController
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
        flatController?.selectController(
            at: index,
            animated: animated,
            completion: completion
        )
    }
}

extension Collection {

    subscript (safe index: Index) -> Element? {
          return indices.contains(index) ? self[index] : nil
      }
}
