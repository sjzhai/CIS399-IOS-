//
//  W8ExampleUITests.swift
//  W8ExampleUITests
//
//  Created by Charles Augustine on 2/15/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import XCTest

class W8ExampleUITests: XCTestCase {
        
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
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		let app = XCUIApplication()
		let tablesQuery = app.tables
		tablesQuery.cells.staticTexts["Orange"].tap()

		let domainEukaryaStaticText = tablesQuery.staticTexts["Domain: Eukarya"]
		domainEukaryaStaticText.tap()
		tablesQuery.staticTexts["Phylum: Magnoliphyta"].tap()
		tablesQuery.staticTexts["Order: Sapindales"].tap()
		tablesQuery.staticTexts["Family: Rutaceae"].tap()
		XCTAssertGreaterThanOrEqual(tablesQuery.element.cells.count, 1)

		let table = app.otherElements.containing(.navigationBar, identifier:"Detail").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
		table.tap()

		let fruitsButton = app.navigationBars["Detail"].buttons["Fruits"]
		fruitsButton.tap()



		tablesQuery.staticTexts["Strawberry"].tap()
		domainEukaryaStaticText.tap()
		table.tap()
		fruitsButton.tap()


		let navBar = app.navigationBars["<#Navigation Item Title#>"]
		let existsPredicate = NSPredicate(format: "exists == TRUE")
		expectation(for: existsPredicate, evaluatedWith: navBar, handler: nil)
		waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
