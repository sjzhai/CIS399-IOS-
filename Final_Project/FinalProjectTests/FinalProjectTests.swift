//
//  FinalProjectTests.swift
//  FinalProjectTests
//
//  Created by Shengjie Zhai on 2017/2/23.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import XCTest
@testable import FinalProject

class FinalProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCategories() {
        //createFetchedResultsController request categories
        let section = DishService.shared.dishCategories().sections?.count
        if let instanceSection = section {
            //test dishCategories instance has sections.
            XCTAssertGreaterThan(instanceSection, 0, "NSFetchedResultsController instance contains more than 0 sections (dishCategories)")
        }else{
            XCTFail("NSFetchedResultsController instance do not contains more than 0 sections (dishCategories)")
        }
        
        let sec = DishService.shared.dishCategories().sections
        if let sections = sec {
            for sec in sections {
                let item = sec.numberOfObjects
                
                //test catCategories section has items.
                XCTAssertGreaterThan(item, 0, "The each sction of NSFetchedResultsController contains more than 0 items (dishCategories)")
            }
        }else{
            XCTFail("The each sction of NSFetchedResultsController do not contains more than 0 items (dishCategories)")
        }
    }
    
    func testContents() {
        
        let contentSection = DishService.shared.dishCategories().fetchedObjects
        if let content = contentSection{
            for item in content{
                let section = DishService.shared.cookRecipe(for: item).fetchedObjects?.count
                if let sec = section {
                    XCTAssertGreaterThan(sec, 0, "NSFetchedResultsController instance contains more than 0 item for (cookRecipe)")
                }else{
                    XCTFail("NSFetchedResultsController instance do not contains more than 0 item for (cookRecipe)")
                }
                
            }
        }
    }
    
    func testfavoriteCategories() {
        let section = DishService.shared.favoriteDishCategories().sections?.count
        if let instanceSection = section {
            //test dishCategories instance has 0 section or greater than 0 sections.
            XCTAssertGreaterThanOrEqual(instanceSection, 0, "NSFetchedResultsController instance contains more than 0 sections (favoriteDishCategories)")
        }else{
            XCTFail("NSFetchedResultsController instance do not contains more than 0 sections (favoriteDishCategories)")
        }
    }
}
