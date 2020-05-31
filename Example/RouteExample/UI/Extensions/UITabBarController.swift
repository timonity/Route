//
//  TabBarController.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 31.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import Route

extension UITabBarController: StoryboadInitable {

    public static var storyboardId: String {
        return "TabBar"
    }

    public static var storyboardName: String {
        return "Main"
    }
}
