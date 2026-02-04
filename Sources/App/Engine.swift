import Foundation

enum ConditionEvaluator {
    static func isMet(_ req: Requirement, state: GameState, pack: StoryPack) -> Bool {
        switch req {
        case .hasFlag(let f): return state.flags.contains(f)
        case .notFlag(let f): return !state.flags.contains(f)
        case .classIs(let c): return state.heroClassId == c
        case .phaseIs(let p): return state.phase(using: pack.definitions.timeModel) == p
        case .statGE(let key, let value): return (state.stats[key] ?? 0) >= value
        case .skillGE(let key, let value): return (state.skills[key] ?? 0) >= value
        case .fatigueLE(let v): return state.fatigue <= v
        case .healthGE(let v): return state.health >= v
        case .anyOf(let reqs): return reqs.contains { isMet($0, state: state, pack: pack) }
        case .allOf(let reqs): return reqs.allSatisfy { isMet($0, state: state, pack: pack) }
        }
    }

    static func allMet(_ reqs: [Requirement]?, state: GameState, pack: StoryPack) -> Bool {
        guard let reqs else { return true }
        return reqs.allSatisfy { isMet($0, state: state, pack: pack) }
    }

    static func isMet(_ wrapper: RequirementWrapper, state: GameState, pack: StoryPack) -> Bool {
        switch wrapper.type {
        case "hasFlag":
            return wrapper.flag.map { state.flags.contains($0) } ?? false
        case "notFlag":
            return wrapper.flag.map { !state.flags.contains($0) } ?? false
        case "phaseIs":
            return wrapper.phase.map { state.phase(using: pack.definitions.timeModel) == $0 } ?? false
        case "classIs":
            return wrapper.classId.map { state.heroClassId == $0 } ?? false
        default:
            return false
        }
    }
}

enum EffectApplier {
    static func apply(_ effect: Effect, state: inout GameState) {
        switch effect {
        case .setFlag(let f): state.flags.insert(f)
        case .removeFlag(let f): state.flags.remove(f)
        case .modifyHealth(let a): state.health += a
        case .fatigue(let d): state.fatigue += d
        case .practiceSkill(let skill, let amount): state.skills[skill, default: 0] += amount
        case .advanceTime(let ticks): state.timeTick += ticks
        case .log(let text): state.log.append(text)
        }
        state.clamp()
    }

    static func applyAll(_ effects: [Effect]?, state: inout GameState) {
        effects?.forEach { apply($0, state: &state) }
    }
}

enum Resolver {
    static func availableChoices(for scene: Scene, state: GameState, pack: StoryPack) -> [Choice] {
        scene.choices.filter { ConditionEvaluator.allMet($0.requires, state: state, pack: pack) }
    }

    static func enterScene(_ sceneId: String, state: inout GameState, pack: StoryPack) {
        guard let scene = pack.sceneById[sceneId] else { return }
        EffectApplier.applyAll(scene.onEnter, state: &state)
        state.currentSceneId = sceneId
        Storage.saveState(state)
    }

    static func pick(_ choice: Choice, state: inout GameState, pack: StoryPack, config: ResolverConfig = .init()) {
        EffectApplier.applyAll(choice.effects, state: &state)

        if let res = choice.resolution, res.isSkillCheck,
           let key = res.skill, let difficulty = res.difficulty, let outcomes = res.outcomes {

            let base = state.skills[key] ?? state.stats[key] ?? 0

            var modTotal = 0
            if let mods = res.modifiers {
                for m in mods where ConditionEvaluator.isMet(m.if, state: state, pack: pack) {
                    modTotal += m.add
                }
            }

            let fatiguePenalty = state.fatigue * config.fatiguePenaltyPerPoint
            let roll = Int.random(in: 0..<config.rngMax)
            let score = base + modTotal + roll - fatiguePenalty

            let chosen: Outcome
            if score >= difficulty + config.successMargin {
                chosen = outcomes.success
            } else if score >= difficulty + config.mixedMargin {
                chosen = outcomes.mixed
            } else {
                chosen = outcomes.fail
            }

            EffectApplier.applyAll(chosen.effects, state: &state)
            enterScene(chosen.to, state: &state, pack: pack)
        } else if let to = choice.to {
            enterScene(to, state: &state, pack: pack)
        } else {
            Storage.saveState(state)
        }
    }
}
