//
//  Assignment6UITests.swift
//  Assignment6UITests
//


import XCTest


class Assignment6UITests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        
        XCTAssertEqual(app.tables.count, 1)
        
        XCTAssertGreaterThan(app.cells.count, 0, "The table elements on the categories list contain more than 0 cell")
        
        app.tables.cells.staticTexts["Contains 3 images"].tap()
        let navBar = app.navigationBars["Cat Images"]
        let existsPredicate = NSPredicate(format: "exists == TRUE")
        expectation(for: existsPredicate, evaluatedWith: navBar, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
        
        let cells = app.collectionViews.cells.count
        XCTAssertGreaterThan(cells, 0, "The cat images screen contains more than 0 cells")
        
        navBar.buttons["Categories"].tap()
        
    }
    
}
