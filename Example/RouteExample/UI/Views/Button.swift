//
//  Button.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 23.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

class Button: UIButton {

    // MARK: Override methods

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.size.height / 4
        layer.masksToBounds = true
    }

    // MARK: Public methods

    convenience init(action: Action, id: Int, tag: Int) {
        self.init()

        self.tag = tag
        accessibilityIdentifier = "\(id)-\(action.title)"

        setTitle(action.title, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .highlighted)

        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        if #available(iOS 11.0, *) {
            backgroundColor = UIColor(named: "main_button")
        }
    }
}
