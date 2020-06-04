//
//  HeaderView.swift
//  RouteExample
//
//  Created by Nikolai Timonin on 04.06.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit
import TableAdapter

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var titleLabel: UILabel!
}

extension HeaderView: Configurable {

    func setup(with item: String) {
        titleLabel.text = item
    }
}
