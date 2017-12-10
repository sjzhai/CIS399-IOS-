//
//  main.swift
//  Assignment1
//

let instance = TriathlonEvent(triathlon: Triathlon.olympic)
    
let SwimmerA = Swimmer(name: "Cassi")
instance.register(SwimmerA)
let SwimmerB = Swimmer(name: "Jason")
instance.register(SwimmerB)
let SwimmerC = Swimmer(name: "Kathy")
instance.register(SwimmerC)

let CyclistA = Cyclist(name: "Asia")
instance.register(CyclistA)
let CyclistB = Cyclist(name: "David")
instance.register(CyclistB)

let RunnerA = Runner(name: "Sign")
instance.register(RunnerA)
let RunnerB = Runner(name: "Becky")
instance.register(RunnerB)

let AthleteA = Athlete(name: "Charles")
instance.register(AthleteA)
let AthleteB = Athlete(name: "Chuck")
instance.register(AthleteB)

instance.simulate()

if instance.winner != nil {
    let participantTime = instance.raceTime(for: instance.winner!)!
    print(instance.winner!.name + " wins first place with a total time of " + String(participantTime) + " minutes!")
}else {
    print("No one finished the race!")
}
