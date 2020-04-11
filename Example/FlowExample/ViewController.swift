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
    
    @IBOutlet var navigationTreeLabel: UILabel!
    
    // MARK: Public properties
    
    var id: Int = 0
    
    var tree: [String] = []
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) {
            navigationTreeLabel.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        } else {
            
        }
    
        plotTree()
    }
    
    // MARK: Private methods
    
    @IBAction func pushButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        
        controller.id = generateNewId()
        controller.tree = growTreeForPush()
        
        router.push(
            controller,
            animated: true,
            completion: { }
        )
    }
    
    @IBAction func presentButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        
        controller.id = generateNewId()
        controller.tree = growTreeForPresent()
        
        router.present(controller)
    }
    
    @IBAction func presentInNavigationButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        
        controller.id = generateNewId()
        controller.tree = growTreeForPresent()
        
        let nc = UINavigationController(rootViewController: controller)
        
        router.present(nc)
    }
    
    @IBAction func exitButtonTouched(_ sender: Any) {
        
        router.back()
    }
    
    @IBAction func replaceButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        controller.id = generateNewId()
        controller.tree = treeWithReplacedLeave()
        
        router.replace(
            to: controller,
            animated: true,
            completion: { }
        )
    }
    
    @IBAction func backToButtonTouched(_ sender: Any) {
        
        let title = "From \(id)"
        
        router.backTo(
            to: ViewController.self,
            animated: true,
            condition: { $0.id == 3 },
            prepare: { $0.title = title }
        )
    }
    
    private func presentTabBar() {
        
        let first = ViewController.initiate()
        
        first.id = generateNewId()
        first.tree = growTreeForPresent()
        
        first.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let firstNav = UINavigationController(rootViewController: first)
        
        let tabBarCotroller = UITabBarController()
        tabBarCotroller.setViewControllers([firstNav], animated: false)
        
        router.present(tabBarCotroller)
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
        
        let c = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        c.addAction(cancel)
        
        router.present(c)
    }
}

// MARK: Navigation Tree

extension ViewController {
    
    private func generateNewId() -> Int {
        
        return id + 1
    }
    
    private func growTreeForPush() -> [String] {
        
        var newTree = tree
        
        var s = newTree.last!
        
        s.append("––[\(generateNewId())]")
        
        newTree[newTree.count - 1] = s
        
        return newTree
    }
    
    private func growTreeForPresent() -> [String] {
        
        var newTree = tree
        
        let last = newTree.last!
        
        let lastLength = last.count - 1
        
        newTree.append(
            " ".duplicate(lastLength - 1) + "|"
        )
        
        newTree.append(
            " ".duplicate(lastLength - 2) + "[\(generateNewId())]"
        )
        
        return newTree
    }
    
    private func treeWithReplacedLeave() -> [String] {
        
        var newTree = tree
        
        var last = newTree.last!
        
        let offset = -2 - String(id).count
        
        let s = last.index(last.endIndex, offsetBy: offset)
        let e = last.index(last.endIndex, offsetBy: 0)
        
        last.replaceSubrange(s..<e, with: "[\(generateNewId())]")
        
        newTree[newTree.count - 1] = last
        
        return newTree
    }
    
    private func plotTree() {
        
        let t = tree.reversed().map { $0.appending("\n") }.reduce("") { (res, ns) -> String in
            
            return res + ns
        }
        
        navigationTreeLabel.text = t
        navigationTreeLabel.numberOfLines = tree.count + 1
    }
}

extension String {
    
    func duplicate(_ times: Int) -> String {
           
        return String(repeating: self, count: times)
    }
}
