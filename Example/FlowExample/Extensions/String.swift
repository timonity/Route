//
//  String.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 23.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Foundation

extension String {
    
    func duplicate(_ times: Int) -> String {
           
        return String(repeating: self, count: times)
    }
}
