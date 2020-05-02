//
//  NavigationTestCase.swift
//  FlowExampleTests
//
//  Created by Nikolai Timonin on 22.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import XCTest

class NavigationTestCase: RouterTestCase {
    
    func testBaclToKeyNavRoot() {
        
        setWindowRoot()
        
        push()
        push()
        
        backToKeyNavRoot()
        
        present()
        
        replace()
        
        push()
        push()
        
        backToKeyNavRoot()
        
        checkStack()
    }
    
    func testInplaceNavigation() {
        
        setWindowRoot()
        
        push()
        
        replace()
        
        present()
        
        replace()
        
        push()
        
        present()
        
        present()
        
        replace()
        
        back()
        
        checkStack()
    }
    
     func testBackTo() {
         
        setWindowRoot()
        
        push()
        push()
        present()
        push()
        present()
        present()
        present()
        push()
        
        backTo(id: 6)
        
        checkTopController()
        
        backTo(id: 3)
        
        backToWindowRoot()
        
        checkStack()
     }
     
     func testExample() throws {
         
         setWindowRoot()
         
         push()
         present()
         
         backToWindowRoot()
         
         checkStack()
     }
     
     func testBackStep() {
         
         steps = [
             [1, 2, 3],
             [4],
             [5, 6],
             [7, 8, 9, 10],
             [11],
             [12]
         ]
     
         for id in stack.reversed().map({ $0.id }) {
             
             backStepTo(id: id)
             
             XCTAssert(stack.last?.id == id, "Fail on id: \(id)")
         }
     }
    
}
