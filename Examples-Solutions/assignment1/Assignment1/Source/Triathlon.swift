//
//  Triathlon.swift
//  Assignment1
//


enum Triathlon {
	case sprint
	case olympic
	case halfIronman
	case ironman

	func distance(for sport: Sport) -> Int {
		let result: Int
		switch (self, sport) {
		case (.sprint, .swimming):
			result = 750
		case (.sprint, .cycling):
			result = 20000
		case (.sprint, .running):
			result = 5000
		case (.olympic, .swimming):
			result = 1500
		case (.olympic, .cycling):
			result = 40000
		case (.olympic, .running):
			result = 10000
		case (.halfIronman, .swimming):
			result = 1930
		case (.halfIronman, .cycling):
			result = 90000
		case (.halfIronman, .running):
			result = 21090
		case (.ironman, .swimming):
			result = 3860
		case (.ironman, .cycling):
			result = 180000
		case (.ironman, .running):
			result = 42200
		}

		return result
	}

	static let sports: Array<Sport> = [.swimming, .cycling, .running]
}
