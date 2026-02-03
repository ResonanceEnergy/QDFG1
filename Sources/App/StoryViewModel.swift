import SwiftUI

@MainActor
final class StoryViewModel: ObservableObject {
    @Published private(set) var pack: StoryPack
    @Published var state: GameState
    @Published var currentScene: Scene

    private let config = ResolverConfig()

    init(pack: StoryPack) {
        self.pack = pack

        if let saved = Storage.loadState(), pack.sceneById[saved.currentSceneId] != nil {
            self.state = saved
        } else {
            self.state = GameState(
                currentSceneId: pack.startSceneId,
                heroClassId: "VANGUARD",
                stats: ["Body": 50, "Mind": 50, "Edge": 50],
                skills: ["Force": 42, "Insight": 28, "Stealth": 22, "Charm": 28, "Warding": 18],
                health: 10,
                fatigue: 0,
                timeTick: 0,
                flags: [],
                log: []
            )
        }

        self.currentScene = pack.sceneById[state.currentSceneId] ?? pack.scenes.first!

        // Apply onEnter once when opening
        Resolver.enterScene(state.currentSceneId, state: &self.state, pack: pack)
        self.currentScene = pack.sceneById[self.state.currentSceneId] ?? self.currentScene
    }

    var phase: String { state.phase(using: pack.definitions.timeModel) }

    func setClass(_ classId: String) {
        ClassDefaults.apply(classId: classId, to: &state)
        Storage.saveState(state)
    }

    func choose(_ choice: Choice) {
        Resolver.pick(choice, state: &state, pack: pack, config: config)
        if let updated = pack.sceneById[state.currentSceneId] {
            currentScene = updated
        }
    }

    func reset() {
        Storage.clearSave()
    }
}
