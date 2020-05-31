//
//  AppDelegate.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 10.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Route

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
