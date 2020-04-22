//
//  ContentController.swift
//  FlowExampleTests
//
//  Created by Nikolai Timonin on 22.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

class ContentController: UIViewController, Controller {
    
    // MARK: Override properites
    
    override var description: String {
        
        return "Content \(id)"
    }
    
    // MARK: Public properties
    
    let id: Int
    
    // MARK: Public methods
    
    init(id: Int) {
        
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
