//
//  NavigationController.swift
//  FlowExampleTests
//
//  Created by Nikolai Timonin on 22.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, Controller {
    
    // MARK: Override properies
    
    override var description: String {
        
        return "Navigat \(id)"
    }
    
    // MARK: Public properties
    
    let id: Int
    
    // MARK: Public methods
    
    init(id: Int, root: UIViewController) {
        
        self.id = id
        
        super.init(rootViewController: root)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
