//
//  ParticipantTests.swift
//  Assignment1UnitTests
//
//  Created by Charles Augustine.
//
//


import XCTest


class ParticipantTests: XCTestCase {
	func testMetersPerMinuteForSwimmingWithNilFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")

		XCTAssertEqual(testParticipant.metersPerMinute(for: .swimming, randomValue: 0.5), 43, "Participant extension metersPerMinute(for:) did not return 43 for Sport.swimming when favoriteSport was nil")
	}

	func testMetersPerMinuteForSwimmingWithSwimmingFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .swimming

		XCTAssertEqual(testParticipant.metersPerMinute(for: .swimming, randomValue: 0.5), 45, "Participant extension metersPerMinute(for:) did not return 45 for Sport.swimming when favoriteSport was Sport.swimming")
	}

	func testMetersPerMinuteForSwimmingWithNonSwimmingFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .running

		XCTAssertEqual(testParticipant.metersPerMinute(for:.swimming, randomValue: 0.5), 38, "Participant extension metersPerMinute(for:) did not return 38 for Sport.swimming when favoriteSport was not Sport.swimming")
	}

	func testMetersPerMinuteForCyclingWithNilFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")

		XCTAssertEqual(testParticipant.metersPerMinute(for:.cycling, randomValue: 0.5), 500, "Participant extension metersPerMinute(for:) did not return 500 for Sport.cycling when favoriteSport was nil")
	}

	func testMetersPerMinuteForCyclingWithCyclingFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .cycling

		XCTAssertEqual(testParticipant.metersPerMinute(for:.cycling, randomValue: 0.5), 525, "Participant extension metersPerMinute(for:) did not return 525 for Sport.cycling when favoriteSport was Sport.cycling")
	}

	func testMetersPerMinuteForCyclingWithNonCyclingFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .running

		XCTAssertEqual(testParticipant.metersPerMinute(for:.cycling, randomValue: 0.5), 450, "Participant extension metersPerMinute(for:) did not return 450 for Sport.cycling when favoriteSport was not Sport.cycling")
	}

	func testMetersPerMinuteForRunningWithNilFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")

		XCTAssertEqual(testParticipant.metersPerMinute(for:.running, randomValue: 0.5), 157, "Participant extension metersPerMinute(for:) did not return 157 for Sport.running when favoriteSport was nil")
	}

	func testMetersPerMinuteForRunningWithRunningFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .running

		XCTAssertEqual(testParticipant.metersPerMinute(for:.running, randomValue: 0.5), 164, "Participant extension metersPerMinute(for:) did not return 164 for Sport.running when favoriteSport was Sport.running")
	}

	func testMetersPerMinuteForRunningWithNonRunningFavoriteSport() {
		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .swimming

		XCTAssertEqual(testParticipant.metersPerMinute(for:.running, randomValue: 0.5), 141, "Participant extension metersPerMinute(for:) did not return 141 for Sport.running when favoriteSport was not Sport.running")
	}

	func testTimeInMinutesToCompleteSportInTriathlon() {
		let testParticipant = TestParticipant(name: "Foo")

		let randomValue = 0.5
		let value = testParticipant.completionTime(for: .swimming, in: .halfIronman, randomValue: randomValue)
		let expectedValue = Triathlon.halfIronman.distance(for: .swimming) / testParticipant.metersPerMinute(for:.swimming, randomValue: randomValue)

		XCTAssertEqual(value, expectedValue, "Participant extension completionTime(for:in:) did not result in the same value as triathlon.distance(for:) / metersPerMinute(for:)")
	}
}
