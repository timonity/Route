//
//  ViewController.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 10.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Route
import TableAdapter

enum Item: Hashable {

    case tree(NavigationTree, Int)
    case action(Action, Int)
}

class ViewController: UIViewController {
    
    // MARK: Private properties

    @IBOutlet private weak var tableView: UITableView!

    private lazy var adapter = TableAdapter<Item, Int>(
        tableView: tableView,
        cellIdentifierProvider: { (indexPath, item) -> String? in

            switch item {

            case .tree:
                return "TreeCell"

            case .action:
                return "ActionCell"
            }
        },
        cellDidSelectHandler: { [weak self] (table, indexPath, item) in
            table.deselectRow(at: indexPath, animated: true)

            switch item {

            case .tree:
                break

            case .action(let value, let id):
                self?.apply(action: value)
            }
        }
    )

    private let forwardAcitons: [Action] = [
        .push,
        .present
    ]

    private let inplaceAcitons: [Action] = [
        .replace,
        .setWindowRoot,
        .jumpTo(3)
    ]

    private let backwardAcitons: [Action] = [
        .back,
        .backTo(3),
        .backToWindowRoot,
        .backToNavigationRoot
    ]

    private lazy var actions: [[Action]] = [
        forwardAcitons,
        inplaceAcitons,
        backwardAcitons
    ]
    
    // MARK: Public properties
    
    var id: Int {
        return navigationTree.id
    }

    var navigationTree: NavigationTree! = NavigationTree.root
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        setupTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateUI()
    }

    // MARK: Private methods

    private func updateUI() {

        let treeSection = Section<Item, Int>(
            id: 0,
            items: [.tree(navigationTree, id)]
        )

        let forwardSection = Section<Item, Int>(
            id: 1,
            items: forwardAcitons.map { Item.action($0, id) },
            header: .custom(item: "Forward")
        )

        let backwardSection = Section<Item, Int>(
            id: 2,
            items: backwardAcitons.map { Item.action($0, id) },
            header: .custom(item: "Backward")
        )

        let inplaceSection = Section<Item, Int>(
            id: 3,
            items: inplaceAcitons.map { Item.action($0, id) },
            header: .custom(item: "Inplace")
        )

        let sections = [
            treeSection,
            forwardSection,
            backwardSection,
            inplaceSection
        ]

        adapter.update(with: sections, animated: false)
    }

    private func setupTable() {
        tableView.register(
            UINib(nibName: "HeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: adapter.defaultHeaderIdentifier
        )
    }

    private func setupTitle() {
        navigationItem.title = String(navigationTree.id)
    }

    private func apply(action: Action) {

        switch action {

        case .push:
            push()

        case .present:
            present()

        case .replace:
            replace()

        case .setWindowRoot:
            setWindowRoot()

        case .jumpTo(let id):
            jumpTo(id)

        case .back:
            back()

        case .backTo(let id):
            backTo(id)

        case .backToWindowRoot:
            backToWindowRoot()

        case .backToNavigationRoot:
            backToNavigationRoot()
        }
    }
    
    private func push() {
        let controller = ViewController.initiate()

        var tree = navigationTree
        tree?.push()

        controller.navigationTree = tree

        router.push(
            controller,
            animated: true,
            completion: { }
        )
    }
    
    private func present() {
        let controller = ViewController.initiate()

        var tree = navigationTree
        tree?.present()

        controller.navigationTree = tree
        
        let nc = UINavigationController(rootViewController: controller)
        
        router.present(nc)
    }
    
    private func replace() {
        let controller = ViewController.initiate()

        var tree = navigationTree
        tree?.replace()

        controller.navigationTree = tree
        
        router.replace(
            with: controller,
            animated: true,
            completion: { }
        )
    }
    
    private func setWindowRoot() {
        let controller = UITabBarController.initiate()
        
        router.setWindowRoot(controller, animated: true, completion: { })
    }

    private func jumpTo(_ id: Int) {
        router.jump(
            to: ViewController.self,
            animated: true,
            condition: { $0.id == id },
            completion: { $0.showAlert(with: "Success!") },
            failure: { self.showAlert(with: "Failure!") }
        )
    }

    private func back() {
        router.back(
            prepare: { (controller: ViewController)  in
                controller.randBg()
            }
        )
    }
    
    private func backTo(_ controllerId: Int) {
        let title = "From \(id)"
        
        router.back(
            to: ViewController.self,
            animated: true,
            condition: { $0.id == controllerId },
            prepare: { $0.title = title },
            completion: { $0.showAlert(with: "Success!") },
            failure: { self.showAlert(with: "Failure!") }
        )
    }
    
    private func backToWindowRoot() {
        router.backToWindowRoot()
    }
    
    private func backToNavigationRoot() {
        router.backToKeyStackRoot()
    }

    // MARK: Public methods

    func randBg() {
        tableView.backgroundColor = .random
    }
}

// MARK: StoryboardInitable

extension ViewController: StoryboadInitable {
    
    static var storyboardName: String {
        return "Main"
    }
}

// MARK: Alert

extension ViewController {

    func showAlert(with message: String) {
        let controller = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        controller.addAction(cancel)
        
        router.present(controller)
    }
}

// MARK: TreeTableViewCell

class TreeTableViewCell: UITableViewCell, Configurable {

    // MARK: Private properties

    @IBOutlet private weak var treeLabel: UILabel!

    // MARK: Override methods

    override func awakeFromNib() {
        super.awakeFromNib()

        if #available(iOS 13.0, *) {
            treeLabel.font = UIFont.monospacedSystemFont(
                ofSize: 16,
                weight: .semibold
            )
        }
    }

    // MARK: Public methods

    func setup(with item: Item) {
        if case let Item.tree(tree, id) = item {
            let plot = tree.plot()

            treeLabel.text = plot.0
            treeLabel.numberOfLines = plot.1

            treeLabel.accessibilityIdentifier = "\(id)-Tree"
        }
    }
}

// MARK: ActionTableViewCell

class ActionTableViewCell: UITableViewCell, Configurable {

    func setup(with item: Item) {
        if case let Item.action(action, id) = item {
            textLabel?.text = action.title

            accessibilityIdentifier = "\(id)-\(action.title)"
        }
    }
}
