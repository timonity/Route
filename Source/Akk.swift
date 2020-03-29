//
//  Akk.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 13.03.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

// MARK: Prepare for unwind

//protocol AnyUnwind {
//    
//    func handleAny(item: Any)
//}

protocol Unwind {
    
    associatedtype ItemType
    
    func handle(item: ItemType)
}

//extension Unwind {
//    
//    func handleAny(item: Any) {
//        
//        handle(item: item as! ItemType)
//    }
//}
