//
//  TestRouter.swift
//  FlowExampleTests
//
//  Created by Nikolai Timonin on 22.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Flow

class TestRouter: Router {
    
    override func navigate(
        with action: BackAction,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
                
        if let controllerToDismiss = action.dismiss {
            
            controllerToDismiss.dismiss(animated: animated) {
                
                self.pop(with: action, animated: false, completion: completion)
            }
            
        } else {
            
            pop(with: action, animated: animated, completion: completion)
        }
    }
    
    private func pop(
        with action: BackAction,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        guard let controllerToPop = action.popTo else {
            
            completion?()
            
            return
        }

//        controllerToPop.navigationController?.pop(
//            to: controllerToPop,
//            animated: animated,
//            completion: completion
//        )
    }
}
