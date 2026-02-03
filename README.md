# QFG1‑Style iPhone Narrative Engine (SwiftUI + JSON)

This repo is a **drop‑in SwiftUI story engine** modeled on the *Quest‑for‑Glory‑I* design feel:
- **Single hero**
- **Three asymmetric classes**
- **Practice‑based skill growth** (skills improve by doing)
- **Narration‑only outcomes** (no “success/fail” UI labels)
- **Time + fatigue pressure**
- **Fail‑forward** (failure changes the situation; it doesn’t stop play)

> ⚠️ **Important**: This project contains **original content** (no copied story, names, or assets).

---

## What’s in here

- `Content/prologue_pack.json` — a playable **Prologue** story pack
- `Sources/App/*.swift` — SwiftUI app scaffolding + engine:
  - JSON loader
  - Choice filtering (class‑locked, flag‑locked, phase‑locked)
  - Skill checks with modifiers
  - Effect application (flags, time, fatigue, health, practice)
  - Autosave
- `Docs/Design/*` — the design docs we built (Hero Model → Class Framework → Scene/Resolution → Prologue)

---

## Quickstart (Xcode iOS App)

> SwiftUI iOS apps still require **Xcode** to build/run on iPhone.

1. **Create a new iOS App** in Xcode:
   - File → New → Project → iOS → **App**
   - Product Name: `QFG1Style`
   - Interface: **SwiftUI**
   - Language: **Swift**

2. **Copy this repo’s files into your Xcode project**:
   - Drag `Sources/App/*.swift` into your Xcode project’s source group
   - Drag `Content/prologue_pack.json` into the project
     - Ensure it’s included in **Copy Bundle Resources**

3. Replace the default app entry if needed:
   - If your Xcode template generated `ContentView.swift` / `YourApp.swift`, you can delete them and keep ours.

4. Build and run.

---

## VS Code workflow

- Open this folder in VS Code.
- Use it for editing Swift + JSON.
- Build/run via Xcode (recommended).

`.vscode/` contains suggested extensions + minimal settings.

---

## Next steps

- Add more packs under `Content/`.
- Expand the condition system (more requirement types).
- Add a dev‑only debug overlay (kept out of release builds).

---

## License

MIT — do what you want.
