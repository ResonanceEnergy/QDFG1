import Foundation

// MARK: - Top-level Pack

struct StoryPack: Codable {
    let packId: String
    let version: String
    let title: String
    let definitions: Definitions
    let startSceneId: String
    let scenes: [Scene]

    var sceneById: [String: Scene] {
        Dictionary(uniqueKeysWithValues: scenes.map { ($0.id, $0) })
    }

    init(title: String, startScene: String, scenes: [Scene]) {
        self.packId = "merged"
        self.version = "1.0.0"
        self.title = title
        self.definitions = Definitions(classes: [], stats: [], skills: [], timeModel: TimeModel(ticksPerPhase: 6, phases: ["Dawn", "Day", "Dusk", "Night"]))
        self.startSceneId = startScene
        self.scenes = scenes
    }
}

struct Definitions: Codable {
    let classes: [ClassDef]
    let stats: [String]
    let skills: [String]
    let timeModel: TimeModel
}

struct ClassDef: Codable {
    let id: String
    let displayName: String
}

struct TimeModel: Codable {
    let ticksPerPhase: Int
    let phases: [String]
}

// MARK: - Scene

struct Scene: Codable {
    let id: String
    let title: String?
    let text: String
    let onEnter: [Effect]?
    let choices: [Choice]
}

// MARK: - Choice

struct Choice: Codable {
    let id: String
    let text: String
    let requires: [Requirement]?
    let effects: [Effect]?
    let resolution: Resolution?
    let to: String?
}

// MARK: - Requirement (polymorphic via "type")

enum Requirement: Codable {
    case hasFlag(String)
    case notFlag(String)
    case classIs(String)
    case phaseIs(String)
    case statGE(key: String, value: Int)
    case skillGE(key: String, value: Int)
    case fatigueLE(Int)
    case healthGE(Int)
    case anyOf([Requirement])
    case allOf([Requirement])

    private enum CodingKeys: String, CodingKey { case type, flag, classId, phase, key, value, requirements }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let type = try c.decode(String.self, forKey: .type)

        switch type {
        case "hasFlag": self = .hasFlag(try c.decode(String.self, forKey: .flag))
        case "notFlag": self = .notFlag(try c.decode(String.self, forKey: .flag))
        case "classIs": self = .classIs(try c.decode(String.self, forKey: .classId))
        case "phaseIs": self = .phaseIs(try c.decode(String.self, forKey: .phase))
        case "statGE": self = .statGE(key: try c.decode(String.self, forKey: .key), value: try c.decode(Int.self, forKey: .value))
        case "skillGE": self = .skillGE(key: try c.decode(String.self, forKey: .key), value: try c.decode(Int.self, forKey: .value))
        case "fatigueLE": self = .fatigueLE(try c.decode(Int.self, forKey: .value))
        case "healthGE": self = .healthGE(try c.decode(Int.self, forKey: .value))
        case "anyOf": self = .anyOf(try c.decode([Requirement].self, forKey: .requirements))
        case "allOf": self = .allOf(try c.decode([Requirement].self, forKey: .requirements))
        default: self = .allOf([])
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .hasFlag(let f): try c.encode("hasFlag", forKey: .type); try c.encode(f, forKey: .flag)
        case .notFlag(let f): try c.encode("notFlag", forKey: .type); try c.encode(f, forKey: .flag)
        case .classIs(let id): try c.encode("classIs", forKey: .type); try c.encode(id, forKey: .classId)
        case .phaseIs(let p): try c.encode("phaseIs", forKey: .type); try c.encode(p, forKey: .phase)
        case .statGE(let key, let v): try c.encode("statGE", forKey: .type); try c.encode(key, forKey: .key); try c.encode(v, forKey: .value)
        case .skillGE(let key, let v): try c.encode("skillGE", forKey: .type); try c.encode(key, forKey: .key); try c.encode(v, forKey: .value)
        case .fatigueLE(let v): try c.encode("fatigueLE", forKey: .type); try c.encode(v, forKey: .value)
        case .healthGE(let v): try c.encode("healthGE", forKey: .type); try c.encode(v, forKey: .value)
        case .anyOf(let reqs): try c.encode("anyOf", forKey: .type); try c.encode(reqs, forKey: .requirements)
        case .allOf(let reqs): try c.encode("allOf", forKey: .type); try c.encode(reqs, forKey: .requirements)
        }
    }
}

// MARK: - Effects

enum Effect: Codable {
    case setFlag(String)
    case clearFlag(String)

    case modifyHealth(Int)
    case fatigue(Int)
    case practiceSkill(skill: String, amount: Int)
    case advanceTime(ticks: Int)
    case log(String)

    private enum CodingKeys: String, CodingKey { case type, flag, amount, skill, ticks, text, delta }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let type = try c.decode(String.self, forKey: .type)

        switch type {
        case "setFlag": self = .setFlag(try c.decode(String.self, forKey: .flag))
        case "removeFlag": self = .removeFlag(try c.decode(String.self, forKey: .flag))
        case "modifyHealth": self = .modifyHealth(try c.decode(Int.self, forKey: .amount))
        case "fatigue": self = .fatigue(try c.decode(Int.self, forKey: .delta))
        case "practiceSkill": self = .practiceSkill(skill: try c.decode(String.self, forKey: .skill), amount: try c.decode(Int.self, forKey: .amount))
        case "advanceTime": self = .advanceTime(ticks: try c.decode(Int.self, forKey: .ticks))
        case "log": self = .log(try c.decode(String.self, forKey: .text))
        default: self = .log("(unknown effect)")
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .setFlag(let f): try c.encode("setFlag", forKey: .type); try c.encode(f, forKey: .flag)
        case .removeFlag(let f): try c.encode("removeFlag", forKey: .type); try c.encode(f, forKey: .flag)
        case .modifyHealth(let a): try c.encode("modifyHealth", forKey: .type); try c.encode(a, forKey: .amount)
        case .fatigue(let d): try c.encode("fatigue", forKey: .type); try c.encode(d, forKey: .delta)
        case .practiceSkill(let s, let a): try c.encode("practiceSkill", forKey: .type); try c.encode(s, forKey: .skill); try c.encode(a, forKey: .amount)
        case .advanceTime(let t): try c.encode("advanceTime", forKey: .type); try c.encode(t, forKey: .ticks)
        case .log(let text): try c.encode("log", forKey: .type); try c.encode(text, forKey: .text)
        }
    }
}

// MARK: - Resolution

struct Resolution: Codable {
    let type: String
    let skill: String?
    let difficulty: Int?
    let modifiers: [ModifierRule]?
    let outcomes: OutcomeSet?

    var isSkillCheck: Bool { type == "skillCheck" }
}

struct ModifierRule: Codable {
    let `if`: RequirementWrapper
    let add: Int
}

struct RequirementWrapper: Codable {
    let type: String
    let flag: String?
    let phase: String?
    let classId: String?
}

struct OutcomeSet: Codable {
    let success: Outcome
    let mixed: Outcome
    let fail: Outcome
}

struct Outcome: Codable {
    let effects: [Effect]?
    let to: String
}
