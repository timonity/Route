//
//  Action.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 23.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Foundation

enum Action: Equatable {
    
    case push
    case present
    
    case replace
    case setWindowRoot
    case jumpTo(Int)
    
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
            return "New Window Root"

        case .jumpTo(let id):
            return "Jump to \(id)"
            
        case .back:
            return "Back"
            
        case .backTo(let id):
            return "Back to \(id)"
            
        case .backToWindowRoot:
            return "To Window Root"
            
        case .backToNavigationRoot:
            return "To Nav. Root"
        }
    }
}
