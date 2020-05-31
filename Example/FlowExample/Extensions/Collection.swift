//
//  Collection.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 31.05.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
          return indices.contains(index) ? self[index] : nil
      }
}
