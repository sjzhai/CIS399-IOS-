//
//  W8ExampleTests.swift
//  W8ExampleTests
//
//  Created by Charles Augustine on 2/13/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import XCTest
@testable import W8Example

class FruitServiceTests : XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

	func testSingleton() {
		let singleton = FruitService.shared

		XCTAssertNotNil(singleton)
	}

	func testFruitsDoesNotReturnNil() {
		let singleton = FruitService.shared

		let resultsController = singleton.fruits()

		XCTAssertNotNil(resultsController)
	}

	func testFruitsSingleSection() {
		let singleton = FruitService.shared

		let resultsController = singleton.fruits()

		XCTAssertEqual(resultsController.sections?.count, 1)
	}

	func testFruitsRowCount() {
		let singleton = FruitService.shared

		let resultsController = singleton.fruits()

		XCTAssertGreaterThanOrEqual(resultsController.sections?[0].numberOfObjects ?? 0, 1)
	}
}
