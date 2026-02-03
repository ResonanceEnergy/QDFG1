import Foundation

struct GameState: Codable {
    var currentSceneId: String
    var heroClassId: String

    var stats: [String: Int]
    var skills: [String: Int]

    var health: Int
    var fatigue: Int

    var timeTick: Int
    var flags: Set<String>
    var log: [String]

    mutating func clamp() {
        health = max(0, min(10, health))
        fatigue = max(0, min(10, fatigue))
    }
}

extension GameState {
    func phase(using timeModel: TimeModel) -> String {
        let tpp = max(1, timeModel.ticksPerPhase)
        let idx = (timeTick / tpp) % max(1, timeModel.phases.count)
        return timeModel.phases[idx]
    }
}
