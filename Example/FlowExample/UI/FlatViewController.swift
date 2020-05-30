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

    private var pageController: PageViewController? {
        return children.first as? PageViewController
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

        pageControl.numberOfPages = controllers.count

        pageController?.childControllers = controllers

        pageController?.didSelectControllerHandler = { [weak self] idx in
            self?.updateUI(index: idx)
        }
    }

    // MARK: Private methods

    private func updateUI(index: Int) {
        titleLabel.text = "Selected controller: \(index)"

        pageControl.currentPage = index
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

extension Collection {

    subscript (safe index: Index) -> Element? {
          return indices.contains(index) ? self[index] : nil
      }
}
