//
//  TriathlonEvent.swift
//  Assignment1
//


class TriathlonEvent {
	// MARK: Public
	func register(_ participant: Participant) {
		guard !eventPerformed else {
			fatalError("register(_:) called while eventPerformed is true")
		}

		participants.append(participant)
		participantTimes[participant.name] = 0
	}

	func simulate(_ sport: Sport, for participant: Participant, randomValue: Double = Double.random()) {
		guard let participantTime = participantTimes[participant.name] else {
			return
		}

		print("\(participant.name) is about to begin \(sport).")

		if sport == participant.favoriteSport || randomValue >= 0.05 {
			let completionTime = participant.completionTime(for: sport, in: triathlon)
			let totalTime = participantTime + completionTime
			participantTimes[participant.name] = totalTime

			print("\(participant.name) finished the \(sport) event in \(completionTime) minutes; their total race time is now \(totalTime) minutes.")
		}
		else {
			participantTimes[participant.name] = nil

			print("\(participant.name) could not finish the \(sport) event and will not finish the race.")
		}
	}

	func simulate() {
		guard !eventPerformed else {
			fatalError("register(_:) called while eventPerformed is true")
		}

		for sport in Triathlon.sports {
			for participant in participants {
				simulate(sport, for: participant)
			}
		}

		eventPerformed = true
	}

	func raceTime(for participant: Participant) -> Int? {
		return participantTimes[participant.name]
	}

	// MARK: Initialization
	init(triathlon: Triathlon) {
		self.triathlon = triathlon
	}

	// MARK: Properties
	private(set) var eventPerformed: Bool = false

	// MARK: Properties (Private)
	private var participants = Array<Participant>()
	private var participantTimes = Dictionary<String, Int>()

	// MARK: Properties (Computed)
	var registeredParticipants: Array<Participant> {
		get {
			return participants
		}
	}
	var winner: Participant? {
		get {
			guard eventPerformed else {
				fatalError("winner accessed while eventPerformed is false")
			}

			// The code below is equivalent to iterating through the participants array with a for-in loop
			// but instead utilizes a recursive function declared on all sequences called reduce.  The reduce
			// function takes two parameters: an initial reduction value for the reduction and a closure.  The
			// closure is called one time for every element in the sequence and takes two parameters: the current
			// reduction and an element from the sequence.  The job of the closure is to reduce all the elements
			// from the sequence into one value ( in this case it finds the winner).
			return participants.reduce(nil, { (currentWinner, participant) -> Participant? in
				guard let participantTime = participantTimes[participant.name] else {
					return currentWinner
				}

				guard let someCurrentWinner = currentWinner, let winningTime = participantTimes[someCurrentWinner.name] else {
					return participant
				}

				guard participantTime < winningTime else {
					return currentWinner
				}

				return participant
			})

			// The commented out code below is equivalent code using iteration instead of the reduce functions
			// recursive style.  It is functionally equivalent.
//			var winner: Participant? = nil
//			for participant in participants {
//				guard let participantTime = participantTimes[participant.name] else {
//					continue
//				}
//
//				guard let currentWinner = winner, let winningTime = participantTimes[currentWinner.name] else {
//					winner = participant
//					continue
//				}
//
//				guard participantTime < winningTime else {
//					continue
//				}
//
//				winner = participant
//			}
//
//			return winner
		}
	}

	// MARK: Properties (Constant)
	let triathlon: Triathlon
}
