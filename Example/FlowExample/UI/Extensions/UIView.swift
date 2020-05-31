//
//  View.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 31.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue  }
        get { return layer.cornerRadius }
    }
}
