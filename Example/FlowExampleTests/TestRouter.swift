//
//  TestRouter.swift
//  FlowExampleTests
//
//  Created by Nikolai Timonin on 22.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import Flow

class TestRouter: Router {
    
    override func navigate(with action: BackAction, animated: Bool = true, completion: Completion? = nil) {
                
                if let controllerToDismiss = action.dismiss {
                    
                    controllerToDismiss.dismiss(animated: animated) {
                        
                        if let controllerToPop = action.popTo {
        
                            controllerToPop.navigationController?.pop(
                                to: controllerToPop,
                                animated: false,
                                completion: completion
                            )
        
                        } else {
        
                            completion?()
                        }
                    }
                    
                    if action.popTo != nil { return }
                }
                
                if let controllerToPop = action.popTo {

                    let isAnimated = (action.dismiss == nil) ? animated : false

                    controllerToPop.navigationController?.pop(
                        to: controllerToPop,
                        animated: isAnimated,
                        completion: completion
                    )
                }
        
    }
    
    
}
