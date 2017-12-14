//
//  Athlete.swift
//  Assignment1
//


class Athlete : Participant {
	// MARK: Initialization
	required init(name: String) {
		self.name = name
	}

	// MARK: Properties (Constant)
	let name: String

	// MARK: Properties (Computed)
	var favoriteSport: Sport? {
		get {
			return nil
		}
	}
}
