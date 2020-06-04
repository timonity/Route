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

enum IItem: Hashable {

    case tree(NavigationTree)
    case action(Action)
}

class ViewController: UIViewController {
    
    // MARK: Private properties

    @IBOutlet private weak var tableView: UITableView!

    private lazy var adapter = TableAdapter<IItem, Int>(
        tableView: tableView,
        sender: self,
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

            case .action(let value):
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

        updateUI()
    }

    // MARK: Private methods

    private func updateUI() {

        let treeSection = Section<IItem, Int>(
            id: 0,
            items: [.tree(navigationTree)]
        )

        let forwardSection = Section<IItem, Int>(
            id: 1,
            items: forwardAcitons.map { IItem.action($0) },
            header: .custom(item: "Forward")
        )

        let backwardSection = Section<IItem, Int>(
            id: 2,
            items: backwardAcitons.map { IItem.action($0) },
            header: .custom(item: "Backward")
        )

        let inplaceSection = Section<IItem, Int>(
            id: 3,
            items: inplaceAcitons.map { IItem.action($0) },
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
//            prepare: { $0.view.backgroundColor = .red },
            completion: { $0.showAlert(with: "Success!") },
            failure: { self.showAlert(with: "Failure!") }
        )
    }

    private func back() {
        router.back(
            prepare: { $0.randBg() }
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
}

extension UIViewController {

    func randBg() {

    }
}

extension UIColor {

    static var random: UIColor {
        return UIColor(
            red: .random(in: 0..<1),
            green: .random(in: 0..<1),
            blue: .random(in: 0..<1),
            alpha: 1.0
        )
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

class TreeTableViewCell: UITableViewCell {

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
}

extension TreeTableViewCell: SenderConfigurable {

    func setup(with item: IItem, sender: ViewController) {
        if case let IItem.tree(tree) = item {
            let plot = tree.plot()
            
            treeLabel.text = plot.0
            treeLabel.numberOfLines = plot.1

            treeLabel.accessibilityIdentifier = "\(sender.id)-Tree"
        }
    }
}

// MARK: ActionTableViewCell

class ActionTableViewCell: UITableViewCell, SenderConfigurable {

    func setup(with item: IItem, sender: ViewController) {
        if case let IItem.action(action) = item {
            textLabel?.text = action.title

            accessibilityIdentifier = "\(sender.id)-\(action.title)"
        }
    }
}
