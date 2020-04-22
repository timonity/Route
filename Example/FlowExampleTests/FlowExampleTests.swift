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

protocol Controller {
    
    var id: Int { get }
}

extension Int: Controller {
    
    var id: Int {
        
        return self
    }
}

class ContentController: UIViewController, Controller {
    
    let id: Int
    
    init(id: Int) {
        
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var description: String {
        
        return "Content \(id)"
    }
}

class NavigationController: UINavigationController, Controller {
    
    let id: Int
    
    init(id: Int, root: UIViewController) {
        
        self.id = id
        
        super.init(rootViewController: root)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var description: String {
        
        return "Navigat \(id)"
    }
}

extension Array where Element == Controller {
    
    func show() {
        
        forEach { (element) in
            
            print(element)
        }
    }
}


class RouterTestCase: XCTestCase {
    
    // MARK: Public properties
    
    var routerInstance: Router!
    
    var window: UIWindow!
    
    var router: Router {
        
        routerInstance.currentController = routerInstance.findTopController()
        
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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        
        backTo(id: 3)
        
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
    
        for id in stack.reversed().map { $0.id } {
            
            backStepTo(id: id)
            
            XCTAssert(stack.last?.id == id, "Fail on id: \(id)")
        }
    }
    
    
    // MARK: Checks
    
    func checkTopController() {
        
        XCTAssert(router.findTopController() === (stack.last as! UIViewController), "Mismatch top controlers")
    }
    
    func checkStack() {
        
        let result = stack.map { $0.id } == (router.stack as! [Controller]).map { $0.id }
        
        print("Router stack:")
        (router.stack as! [Controller]).show()
        
        print("\nActual stack:")
        stack.show()
        
        XCTAssert(result, "Mismatch actual stack and router stack")
    }
    
    // MARK: Forward Navigation
    
    func present() {
        
        let controller = ContentController(id: currentId + 2)
        let navigation = NavigationController(id: currentId + 1, root: controller)
        
        let expectation = XCTestExpectation(description: "Present")
        
        router.present(navigation, animated: false, completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps.append([navigation, controller])
    }
    
    func push() {
        
        let controller = ContentController(id: currentId + 1)
        
        let expectation = XCTestExpectation(description: "Push")

        router.push(controller, animated: false, completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps.append([controller])
    }
    
    // MARK: Backward Navigation
    
    func back() {
        
        let expectation = XCTestExpectation(description: "Back")
        
        router.back(animated: false, completion: { _ in expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps.removeLast()
    }
    
    func backToWindowRoot() {
        
        let expectation = XCTestExpectation(description: "Back to window root")
        
        router.backToWindowRoot(animated: false, completion: { _ in expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps = [steps[0]]
    }
    
    func backTo(id: Int) {
        
        let expectation = XCTestExpectation(description: "Back to controller with id: \(id)")
        
        router.backTo(
            to: ContentController.self,
            animated: false,
            condition: {  $0.id == id },
            completion: { _ in expectation.fulfill() }
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
        
        let expectation = XCTestExpectation(description: "Set window root")
        
        router.setWindowRoot(navigation, animated: false, completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        
        steps.append([navigation, controller])
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
