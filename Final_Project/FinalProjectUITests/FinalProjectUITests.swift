//
//  FinalProjectUITests.swift
//  FinalProjectUITests
//
//  Created by Shengjie Zhai on 2017/2/23.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import XCTest

class FinalProjectUITests: XCTestCase {
        
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
        app.tables.staticTexts["Orange Chicken"].tap()
        app.navigationBars["Recipe"].buttons["Dish List"].tap()
        XCUIApplication().tabBars.buttons["My Recipes"].tap()
        app.navigationBars["Make Recipe"].buttons["Add"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"name").children(matching: .textField).element.typeText("1")
        
        let tablesQuery2 = tablesQuery
        tablesQuery2.textFields["Enter the taste"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"Description").children(matching: .textField).element.typeText("2")
        tablesQuery2.textFields["Enter ingredients will use"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"ingredients").children(matching: .textField).element.typeText("3")
        tablesQuery2.textFields["Describe every step"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"Steps").children(matching: .textField).element.typeText("4")
        app.navigationBars["Create Recipe"].buttons["Done"].tap()
        
    }
    
}
