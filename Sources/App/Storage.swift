import Foundation

enum Storage {
    static func loadPack(named filename: String) throws -> StoryPack {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "PackLoader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Pack JSON not found in bundle."])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(StoryPack.self, from: data)
    }

    static func saveURL() throws -> URL {
        let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return dir.appendingPathComponent("savegame.json")
    }

    static func saveState(_ state: GameState) {
        do {
            let url = try saveURL()
            let data = try JSONEncoder().encode(state)
            try data.write(to: url, options: [.atomic])
        } catch {
            // Silent by design for release feel.
        }
    }

    static func loadState() -> GameState? {
        do {
            let url = try saveURL()
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(GameState.self, from: data)
        } catch {
            return nil
        }
    }

    static func clearSave() {
        do {
            let url = try saveURL()
            try FileManager.default.removeItem(at: url)
        } catch { }
    }
}
