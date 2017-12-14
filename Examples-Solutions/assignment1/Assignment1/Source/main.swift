//
//  main.swift
//  Assignment1
//


let event = TriathlonEvent(triathlon: .olympic)

event.register(Swimmer(name: "Cassi"))
event.register(Swimmer(name: "Jason"))
event.register(Swimmer(name: "Kathy"))
event.register(Cyclist(name: "Asia"))
event.register(Cyclist(name: "David"))
event.register(Runner(name: "Sigh"))
event.register(Runner(name: "Becky"))
event.register(Athlete(name: "Charles"))
event.register(Athlete(name: "Chuck"))

event.simulate()

if let winner = event.winner, let winningTime = event.raceTime(for: winner) {
	print("\(winner.name) wins first place with a total time of \(winningTime) minutes!")
}
else {
	print("No one finished the race!")
}
