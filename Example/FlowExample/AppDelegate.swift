//
//  AppDelegate.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 10.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Flow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var router = Router(window: window)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let root = ViewController.initiate()
        root.title = "Root"
        root.tree.append("[WinRoot]")
        root.id = 0
        
        router.setWindowRoot(root, animated: false)
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

// MARK: Router

extension UIViewController {
    
    var router: Router {
        
        let keyRouter = (UIApplication.shared.delegate as! AppDelegate).router
        
        keyRouter.currentController = self
        
        return keyRouter
    }
}
