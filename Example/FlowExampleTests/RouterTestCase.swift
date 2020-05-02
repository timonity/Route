//
//  FlowExampleTests.swift
//  FlowExampleTests
//
//  Created by Nikolai Timonin on 18.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import XCTest
import FlowExample
import Flow

class RouterTestCase: XCTestCase {
    
    // MARK: Public properties
    
    var routerInstance: Router!
    
    var window: UIWindow!
    
    var router: Router {
        
        routerInstance.currentController = routerInstance.topController
        
        return routerInstance
    }
    
    var steps: [[Controller]]!
    
    var stack: [Controller] {
        
        return steps.flatMap { $0 }
    }
    
    var currentId: Int {
        
        return stack.last?.id ?? 0
    }
    
    // MARK: Override methods

    override func setUpWithError() throws {
        
        window = UIWindow()
        window.makeKeyAndVisible()
        
        routerInstance = TestRouter(window: window)
        
        steps = []
    }
    
    // MARK: Checks
    
    func checkTopController() {
        
        XCTAssert(router.topController === (stack.last as! UIViewController), "Mismatch top controlers")
    }
    
    func checkStack() {
        
        let result = stack.map { $0.id } == (router.backStack as! [Controller]).map { $0.id }
        
        print("Router stack:")
        (router.backStack as! [Controller]).show()
        
        print("\nActual stack:")
        stack.show()
        
        XCTAssert(result, "Mismatch actual stack and router stack")
    }
    
    // MARK: Forward Navigation
    
    func present() {
        
        let controller = ContentController(id: currentId + 2)
        let navigation = NavigationController(id: currentId + 1, root: controller)
        
        let expectation = XCTestExpectation(description: "Present completion")
        
        router.present(navigation, animated: false, completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps.append([navigation, controller])
    }
    
    func push() {
        
        let controller = ContentController(id: currentId + 1)
        
        let expectation = XCTestExpectation(description: "Push completion")

        router.push(controller, animated: false, completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps.append([controller])
    }
    
    // MARK: Backward Navigation
    
    func back() {
        
        let expectation = XCTestExpectation(description: "Back completion")
        
        router.back(animated: false, completion: { _ in expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps.removeLast()
    }
    
    func backToWindowRoot() {
        
        let expectation = XCTestExpectation(description: "Back to window root completion")
        
        router.backToWindowRoot(animated: false, completion: { _ in expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps = [steps[0]]
    }
    
    func backTo(id: Int) {
        
        let expectation = XCTestExpectation(description: "Back to controller with id: \(id) completion")
        
        router.backTo(
            to: ContentController.self,
            animated: false,
            condition: {  $0.id == id },
            completion: { _ in expectation.fulfill() }
        )
        
        wait(for: [expectation], timeout: 1)
        
        backStepTo(id: id)
    }
    
    func backToKeyNavRoot() {
        
        let expectation = XCTestExpectation(description: "Back to current navigation root")
        
        var id = 0
        
        router.backToKeyNavigationRoot(animated: false, completion: { (contoller: ContentController) in
            
                id = contoller.id

                expectation.fulfill()
            }
        )
        
        wait(for: [expectation], timeout: 1)
        
        backStepTo(id: id)
    }
    
    // MARK: Stack/Steps
    
    func backStepTo(id: Int) {
        
        steps.removeAll { (step) -> Bool in
            
            return step.map { $0.id }.min()! > id
        }
        
        steps[steps.count - 1].removeAll { $0.id > id }
    }
    
    // MARK: Inplace Navigation
    
    func setWindowRoot() {
        
        let controller = ContentController(id: currentId + 2)
        let navigation = NavigationController(id: currentId + 1, root: controller)
        
        let expectation = XCTestExpectation(description: "Set window root completion")
        
        router.setWindowRoot(navigation, animated: false, completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps.append([navigation, controller])
    }
    
    func replace() {
        
        let contoller = ContentController(id: currentId)
        
        let expectation = XCTestExpectation(description: "Replace completion")
        
        router.replace(to: contoller, animated: false, completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps[steps.count - 1].removeLast()
        steps[steps.count - 1].append(contoller)
    }
}
