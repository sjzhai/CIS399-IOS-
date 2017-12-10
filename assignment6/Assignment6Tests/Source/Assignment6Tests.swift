//
//  Assignment6Tests.swift
//  Assignment6Tests
//

import UIKit
import XCTest
@testable import Assignment6

class Assignment6Tests: XCTestCase {
    
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
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCategories() {
        //createFetchedResultsController request categories
        let section = CatService.shared.catCategories().sections?.count
        if let instanceSection = section {
            //test catCategories instance has sections.
            XCTAssertGreaterThan(instanceSection, 0, "NSFetchedResultsController instance contains more than 0 sections (catCategories)")
        }else{
            XCTFail("NSFetchedResultsController instance do not contains more than 0 sections (catCategories)")
        }
        
        let sec = CatService.shared.catCategories().sections
        if let sections = sec {
            for sec in sections {
                let item = sec.numberOfObjects
                
                //test catCategories section has items.
                XCTAssertGreaterThan(item, 0, "The each sction of NSFetchedResultsController contains more than 0 items (catCategories)")
                
            }
        }else{
            XCTFail("The each sction of NSFetchedResultsController do not contains more than 0 items (catCategories)")
        }
    
        
        
    }
    
    func testImages() {
        
        let catSection = CatService.shared.catCategories().fetchedObjects
        if let cat = catSection{
            for item in cat{
                let section = CatService.shared.images(for: item ).fetchedObjects?.count
                if let sec = section {
                    XCTAssertGreaterThan(sec, 0, "NSFetchedResultsController instance contains more than 0 item for (images)")
                }else{
                    XCTFail("NSFetchedResultsController instance do not contains more than 0 item for (images)")
                }
                
            }
        }
        
    }
}
