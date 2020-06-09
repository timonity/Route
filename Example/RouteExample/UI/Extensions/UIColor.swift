//
//  UIColor.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 09.06.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

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
