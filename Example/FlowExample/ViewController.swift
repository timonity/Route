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
        
        let msg = """
        Parent: \(parent)
        Presenting: \(presentingViewController)
        Presented: \(presentedViewController)
        """
        
        print(msg)
        
        let treeDescr = tree.reduce("") { (res, nx) -> String in
            
            return res + "->" + nx
        }
        
        navigationTreeLabel.text = treeDescr
    }
    
    // MARK: Private methods
    
    func getTree(newNode: String) -> [String] {
        
        var currTree = tree
        currTree.append(newNode)
        
        return currTree
    }
    
    @IBAction func pushButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        controller.tree = getTree(newNode: "(\(id + 1))")
        controller.id = id + 1
        
        let animator: Animator? = (id % 2 != 0) ? FadeAnimator() : nil
        
        router.push(controller, animator: animator)
    }
    
    @IBAction func presentButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        controller.tree = getTree(newNode: "[\(id + 1)]")
        controller.id = id + 1
        
        controller.modalPresentationStyle = .fullScreen
        
        let animator: Animator? = (id % 2 == 0) ? FadeAnimator() : nil
        
        router.present(controller, animator: animator)
    }
    
    @IBAction func presentInNavigationButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        controller.tree = getTree(newNode: "[\(id + 1)]")
        controller.id = id + 1
        
        let nc = UINavigationController(rootViewController: controller)
        
        router.present(nc)
    }
    
    @IBAction func exitButtonTouched(_ sender: Any) {
        
        router.exit()
    }
    
    @IBAction func replaceButtonTouched(_ sender: Any) {
        
        let controller = ViewController.initiate()
        
        var t = tree
        t[t.count - 1] = "{\(id + 1)}"
        controller.tree = t
        
        controller.id = id + 1
        
        router.replace(to: controller)
    }
    
    @IBAction func backToButtonTouched(_ sender: Any) {
        
        let title = "From \(id)"
        
        router.back(
            to: ViewController.self,
            condition: { $0.id == 3 },
            prepare: { $0.view.backgroundColor = .gray },
            completion: { $0.showAlert(with: title) }
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
        
        let c = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        c.addAction(cancel)
        
        router.present(c)
    }
}
