//
//  ViewController.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 10.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Route

class ViewController: UIViewController {
    
    // MARK: Private properties
    
    @IBOutlet private weak var forwardStackView: UIStackView!
    @IBOutlet private weak var inplaceStackView: UIStackView!
    @IBOutlet private weak var backwardStackView: UIStackView!

    var stacks: [UIStackView] {
        return [forwardStackView, inplaceStackView, backwardStackView]
    }

    @IBOutlet private var navigationTreeLabel: UILabel!

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
        
        setupButtons()
        
        if #available(iOS 13.0, *) {
            navigationTreeLabel.font = UIFont.monospacedSystemFont(
                ofSize: 15,
                weight: .regular
            )
        }

        let plot = navigationTree.plot()

        navigationTreeLabel.text = plot.0
        navigationTreeLabel.numberOfLines = plot.1

        navigationTreeLabel.accessibilityIdentifier = "\(id)-Tree"

        navigationItem.title = String(navigationTree.id)
    }

    // MARK: Private methods
    
    private func setupButtons() {

        for (i, actions) in actions.enumerated() {
            for (j, action) in actions.enumerated() {

                let tag = i * 10 + j

                let button = Button(action: action, id: id, tag: tag)

                button.addTarget(
                    self,
                    action: #selector(self.actionButtonTouched(_:)),
                    for: .touchUpInside
                )

                stacks[i].addArrangedSubview(button)
            }
        }
    }
    
    @objc private func actionButtonTouched(_ sender: Button) {

        let i = sender.tag / 10
        let j = sender.tag % 10

        switch actions[i][j] {

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
            to: controller,
            animated: true,
            completion: { }
        )
    }
    
    private func setWindowRoot() {
        let controller = UITabBarController.initiate()
        
        router.setWindowRoot(controller, animated: true, completion: { })
    }

    private func jumpTo(_ id: Int) {

        router.jumpTo(
            ViewController.self,
            animated: true,
            condition: { $0.id == id },
            prepare: { $0.view.backgroundColor = .red },
            completion: { $0.showAlert(with: "Jumped from \(self.id)") },
            failure: { self.showAlert(with: "Not found") }
        )
    }

    private func back() {
        router.back()
    }
    
    private func backTo(_ controllerId: Int) {
        let title = "From \(id)"
        
        router.backTo(
            ViewController.self,
            animated: true,
            condition: { $0.id == controllerId },
            prepare: { $0.title = title },
            completion: { _ in  },
            failure: { self.showAlert(with: "Not found") }
        )
    }
    
    private func backToWindowRoot() {
        router.backToWindowRoot()
    }
    
    private func backToNavigationRoot() {
        router.backToKeyStackRoot()
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
