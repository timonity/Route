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

        let controller = UITabBarController.initiate()
        
        router.setWindowRoot(
            controller,
            animated: false,
            completion: { }
        )
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

// MARK: Router

public extension UIViewController {
    
    var router: Router {
        return Router(window: UIApplication.shared.keyWindow, controller: self)
    }
}

extension UITabBarController: StoryboadInitable {
    
    public static var storyboardId: String {
        
        return "TabBar"
    }
    
    public static var storyboardName: String {
        
        return "Main"
    }
    
}
