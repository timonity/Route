//
//  Controller.swift
//  FlowExampleTests
//
//  Created by Nikolai Timonin on 28.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Foundation

protocol Controller {
    
    var id: Int { get }
}

extension Int: Controller {
    
    var id: Int {
        
        return self
    }
}

extension Array where Element == Controller {
    
    func show() {
        
        forEach { (element) in
            
            print(element)
        }
    }
}
