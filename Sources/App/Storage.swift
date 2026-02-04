import Foundation

enum StorageError: Error {
    case missingResource(String)
    case decodeFailed(String)
    case noStartScene
}

struct Storage {
    // MARK: - Public API

    /// Load a single StoryPack JSON from bundle (existing behavior).
    static func loadPack(named name: String) throws -> StoryPack {
        let url = try bundleURL(for: name)
        let data = try Data(contentsOf: url)
        do {
            return try JSONDecoder().decode(StoryPack.self, from: data)
        } catch {
            throw StorageError.decodeFailed("Failed to decode \(name): \(error)")
        }
    }

    /// Load multiple packs and merge them into one runtime StoryPack.
    /// Order matters: earlier packs win on duplicate scene IDs and startScene selection.
    static func loadMergedPacks(named names: [String]) throws -> StoryPack {
        var merged = StoryPack(title: "MergedPack", startScene: "", scenes: [])

        var seenSceneIDs = Set<String>()
        var startSceneChosen: String? = nil

        for name in names {
            let pack = try loadPack(named: name)

            // Start scene: first non-empty wins
            if startSceneChosen == nil, !pack.startScene.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                startSceneChosen = pack.startScene
            }

            // Merge scenes with "first wins" rule
            for scene in pack.scenes {
                if seenSceneIDs.contains(scene.id) {
                    // Duplicate ID: keep the first one, skip this.
                    // If you prefer override behavior, you can remove the old scene and replace it instead.
                    print("⚠️ Duplicate scene id '\(scene.id)' found in \(name). Keeping the earlier definition.")
                    continue
                }
                seenSceneIDs.insert(scene.id)
                merged.scenes.append(scene)
            }

            // Keep a reasonable title if present (first non-empty wins)
            if merged.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               !pack.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                merged.title = pack.title
            }
        }

        guard let start = startSceneChosen else {
            throw StorageError.noStartScene
        }
        merged.startScene = start

        return merged
    }

    // MARK: - Savegame (existing behavior)

    static func saveGameURL() throws -> URL {
        let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return dir.appendingPathComponent("savegame.json")
    }

    static func save(state: GameState) throws {
        let url = try saveGameURL()
        let data = try JSONEncoder().encode(state)
        try data.write(to: url, options: [.atomic])
    }

    static func loadSavedState() throws -> GameState? {
        let url = try saveGameURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(GameState.self, from: data)
    }

    // MARK: - Helpers

    private static func bundleURL(for name: String) throws -> URL {
        // name should include ".json"
        let parts = name.split(separator: ".")
        let resource = parts.first.map(String.init) ?? name
        let ext = parts.count > 1 ? String(parts.last!) : "json"

        guard let url = Bundle.main.url(forResource: resource, withExtension: ext, subdirectory: "Content") else {
            throw StorageError.missingResource("Missing Content/\(name) in bundle.")
        }
        return url
    }
}
