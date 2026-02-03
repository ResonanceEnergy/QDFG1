import Foundation

// Forgiving early-game tuning (narration-only outcomes)
struct ResolverConfig {
    var rngMax: Int = 100
    var successMargin: Int = 15
    var mixedMargin: Int = 0
    var fatiguePenaltyPerPoint: Int = 1
}

enum ClassDefaults {
    static func apply(classId: String, to state: inout GameState) {
        state.heroClassId = classId
        state.stats = ["Body": 50, "Mind": 50, "Edge": 50]
        state.health = 10
        state.fatigue = 0

        switch classId {
        case "VANGUARD":
            state.skills = ["Force": 42, "Insight": 28, "Stealth": 22, "Charm": 28, "Warding": 18]
        case "ARCANIST":
            state.skills = ["Force": 20, "Insight": 40, "Stealth": 24, "Charm": 26, "Warding": 42]
        case "SHADE":
            state.skills = ["Force": 22, "Insight": 30, "Stealth": 44, "Charm": 30, "Warding": 20]
        default:
            state.skills = ["Force": 30, "Insight": 30, "Stealth": 30, "Charm": 30, "Warding": 30]
        }

        state.clamp()
    }
}
