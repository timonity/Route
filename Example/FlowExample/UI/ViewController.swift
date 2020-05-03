//
//  ViewController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 10.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Flow

class ViewController: UIViewController {
    
    // MARK: Private properties
    
    @IBOutlet private var navigationTreeLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    private let actions = Action.allCases
    
    // MARK: Public properties
    
    var id: Int {

        return navigationTree.id
    }

    var navigationTree: NavigationTree!
    
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

        title = String(navigationTree.id)
    }
    
    // MARK: Private methods
    
    private func setupButtons() {
        
        actions.forEach { (action) in
            
            let button = Button()

            button.setupWith(action: action)
            button.addTarget(
                self,
                action: #selector(self.actionButtonTouched(_:)),
                for: .touchUpInside
            )
            
            stackView.addArrangedSubview(button)   
        }
    }
    
    @objc private func actionButtonTouched(_ sender: Button) {
        
        guard let action = Action(rawValue: sender.tag) else { return }
        
        switch action {
            
        case .push:
            push()
            
        case .present:
            present()
            
        case .replace:
            replace()
            
        case .setWindowRoot:
            setWindowRoot()
            
        case .back:
            back()
            
        case .backTo:
            backTo(3)
            
        case .backToWindowRoot:
            backToWindowRoot()
            
        case .backToNavigationRoot:
            backToNavigationRoot()
        }
    }
    
    private func push() {
        
        let controller = ViewController.initiate()

        var tree = navigationTree
        tree?.growWithPush()

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
        tree?.growWithPresent()

        controller.navigationTree = tree
        
        let nc = UINavigationController(rootViewController: controller)
        
        router.present(nc)
    }
    
    private func replace() {
        
        let controller = ViewController.initiate()

        var tree = navigationTree
        tree?.growWithReplace()

        controller.navigationTree = tree
        
        router.replace(
            to: controller,
            animated: true,
            completion: { }
        )
    }
    
    private func setWindowRoot() {
        
        let root = ViewController.initiate()
        root.navigationTree = NavigationTree.root
        
        let navigation = UINavigationController(rootViewController: root)
        
        router.setWindowRoot(navigation, animated: true, completion: { })
    }

    private func back() {
        
        router.back()
    }
    
    private func backTo(_ controllerId: Int) {
        
        let title = "From \(id)"
        
        router.backTo(
            to: ViewController.self,
            animated: true,
            condition: { $0.id == controllerId },
            prepare: { $0.title = title }
        )
    }
    
    private func backToWindowRoot() {
        
        router.backToWindowRoot()
    }
    
    private func backToNavigationRoot() {
        
        router.backToKeyNavigationRoot()
    }
    
//    private func presentTabBar() {
//        
//        let first = ViewController.initiate()
//        
//        first.id = generateNewId()
//        first.tree = growTreeForPresent()
//        
//        first.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//
//        let firstNav = UINavigationController(rootViewController: first)
//        
//        let tabBarCotroller = UITabBarController()
//        tabBarCotroller.setViewControllers([firstNav], animated: false)
//        
//        router.present(tabBarCotroller)
//    }
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
        
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        controller.addAction(cancel)
        
        router.present(controller)
    }
}
