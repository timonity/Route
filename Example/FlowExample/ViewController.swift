//
//  ViewController.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 10.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Flow

enum Action: Int, CaseIterable {
    
    case push
    case present
    
    case replace
    case setWindowRoot
    
    case back
    case backTo
    case backToWindowRoot
    case backToNavigationRoot
    
    
    var title: String {
        
        switch self {
            
        case .push:
            return "Push"
            
        case .present:
            return "Present"
            
        case .replace:
            return "Replace"
            
        case .setWindowRoot:
            return "Set Window Root"
            
        case .back:
            return "Back"
            
        case .backTo:
            return "Back to 3"
            
        case .backToWindowRoot:
            return "Back to Window Root"
            
        case .backToNavigationRoot:
            return "Back to Current Nav. Root"
        }
    }
}

class Button: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height / 2
//        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    func setupWith(action: Action) {
        
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        if #available(iOS 11.0, *) {
            backgroundColor = UIColor(named: "main_button")!
        } else {
            
        }
        
        
        
        setTitle(action.title, for: .normal)
        tag = action.rawValue
    }
}

class ViewController: UIViewController {
    
    // MARK: Private properties
    
    @IBOutlet var navigationTreeLabel: UILabel!
    
    private let actions = Action.allCases
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: Public properties
    
    var id: Int = 0
    
    var tree: [String] = []
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        
        if #available(iOS 13.0, *) {
            navigationTreeLabel.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        } else {
            
        }
        
        title = String(id)
        
        navigationTreeLabel.backgroundColor = .white
    
        plotTree()
    }
    
    // MARK: Private methods
    
    private func setupButtons() {
        
        actions.forEach { (action) in
            
            let button = Button()
            button.setupWith(action: action)
            button.addTarget(self, action: #selector(self.actionButtonTouched(_:)), for: .touchUpInside)
            
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
        
        controller.id = generateNewId()
        controller.tree = growTreeForPush()
        
        router.push(
            controller,
            animated: true,
            completion: { }
        )
    }
    
    private func present() {
        
        let controller = ViewController.initiate()
        
        controller.id = generateNewId()
        controller.tree = growTreeForPresent()
        
        let nc = UINavigationController(rootViewController: controller)
        
        router.present(nc)
    }
    
    private func replace() {
        
        let controller = ViewController.initiate()
        controller.id = generateNewId()
        controller.tree = treeWithReplacedLeave()
        
        router.replace(
            to: controller,
            animated: true,
            completion: { }
        )
    }
    
    private func setWindowRoot() {
        
        let root = ViewController.initiate()
        root.title = "Root"
        root.id = 0
        root.tree.append("->[\(root.id)]")
        
        let navigation = UINavigationController(rootViewController: root)
        
        router.setWindowRoot(navigation, animated: true, completion: { })
    }

    
    private func back() {
        
        router.back()
    }
    
    private func backTo(_ id: Int) {
        
        let title = "From \(id)"
        
        router.backTo(
            to: ViewController.self,
            animated: true,
            condition: { $0.id == id },
            prepare: { $0.title = title }
        )
    }
    
    private func backToWindowRoot() {
        
        router.backToWindowRoot()
    }
    
    private func backToNavigationRoot() {
        
        router.backToKeyNavigationRoot()
    }
    
    
    
    
    @IBAction func presentButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        
        controller.id = generateNewId()
        controller.tree = growTreeForPresent()
        
        router.present(controller)
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
