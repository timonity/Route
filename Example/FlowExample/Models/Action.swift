//
//  Action.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 23.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Foundation

enum Action {
    
    case push
    case present
    
    case replace
    case setWindowRoot
    
    case back
    case backTo(Int)
    case backToWindowRoot
    case backToNavigationRoot
    
    var title: String {
        
        switch self {
            
        case .push:
            return "Push"
            
        case .present:
            return "Present"
            
        case .replace:
            return "Replace"
            
        case .setWindowRoot:
            return "Set Window Root"
            
        case .back:
            return "Back"
            
        case .backTo(let id):
            return "Back to \(id)"
            
        case .backToWindowRoot:
            return "Back to Window Root"
            
        case .backToNavigationRoot:
            return "Back to Current Nav. Root"
        }
    }
}
