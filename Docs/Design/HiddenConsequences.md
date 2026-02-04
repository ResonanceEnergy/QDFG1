# Hidden Consequences Doctrine (Flags + Spent Gates)

This engine uses **hidden flags** to drive long-term consequences while showing the player only immediate state:
- Time phase
- Fatigue
- Health

Outcomes are narration-only (no "Success/Fail" labels, no percentages), and failure must be **fail-forward** (changes the situation but never dead-ends).

This doctrine defines how to implement **one-time consequences** and "consumed" triggers without `clearFlag`.

---

## 1) The Two-Flag Model: Cause + Spent

When a consequence should happen **only once**, model it with two flags:

### A) Cause Flag (What happened)
A persistent historical marker.
- Examples:
  `WILD_OB1_TRAIL_HEAT` (you left a readable trail)
  `HUB_WATCHLIST` (town attention has sharpened)

### B) Spent Flag (Consequence processed)
A one-time marker that prevents repeating the same consequence chain.
- Examples:
  `WILD_OB2_HEAT_SPENT`
  `HUB_PATROLS_ESCALATION_SPENT`

---

## 2) Canonical Pattern: "Consumption" via Gating

Because the engine currently has no `clearFlag`, "consuming" is implemented by **gating**:

### Trigger Gate (requirements)
An event / scene / choice is reachable only if:
- `hasFlag: CAUSE_FLAG`
- `notFlag: SPENT_FLAG`

### Resolution Rule (effects)
Every outcome must set:
- `SPENT_FLAG`

This makes the consequence **fire once** while preserving history for future content.

---

## 3) Why We Prefer This Pattern

### Auditability (history is never lost)
Cause flags remain true, so content can still reference "what happened" later.

### Composability (multiple consequences from one cause)
One cause flag can lead to multiple one-time consequences, each with its own spent flag.

### Fail-forward safety (no loops)
Players don't get forced through the same encounter repeatedly; the spent flag prevents replay loops.

---

## 4) Naming Conventions (Recommended)

### Cause flags (persistent history)
- `*_TRAIL_HEAT`
- `*_SUSPICION`
- `*_OFFENDED`
- `*_DANGER_MARK_*`

Examples:
- `WILD_OB1_TRAIL_HEAT`
- `HUB_WATCHLIST`
- `WILD_DANGER_MARK_1`

### Spent flags (one-time processing)
- `*_SPENT`
- `*_RESOLVED`
- `*_PROCESSED`

Examples:
- `WILD_OB2_HEAT_SPENT`
- `HUB_PATROLS_ESCALATION_SPENT`
- `HUB_FAVOR_SPENT`

### Escalation/baseline flags (persistent world state)
These represent "the world is different now" and remain true:
- `HUB_PATROLS_TIGHTENED`
- `WILD_DANGER_1`, `WILD_DANGER_2`

---

## 5) When NOT to Use "Spent"

Use spent gating for **one-time consequence moments**.

Do NOT use spent gating for a flag that represents a stable condition (baseline):
- Being watched (`HUB_WATCHLIST`) can remain true.
- Tightened patrols (`HUB_PATROLS_TIGHTENED`) can remain true.

Instead: use a spent flag to make the *transition into that baseline* happen once:
- `HUB_PATROLS_ESCALATION_SPENT`

---

## 6) Future-proofing if `clearFlag` is added

If a future engine update supports:
- `{ "type":"clearFlag", "flag":"..." }`

Keep the doctrine anyway:
- Continue setting spent flags for history + debugging.
- Optionally clear cause flags for cleanliness, but do not rely on absence alone to infer history.

---

## Note: `removeFlag` Exists (But "Spent" Is Still Preferred)

The engine supports `removeFlag`, so it is technically possible to "truly consume" a cause flag by clearing it.

However, **the preferred pattern is still: Cause + Spent**, because it preserves history and supports future branching and debugging.

**Recommended:**
- Keep cause flags (history): e.g., `WILD_OB1_TRAIL_HEAT`
- Spend consequences once via gating: e.g., `WILD_OB2_HEAT_SPENT`

**Optional (rare):**
- Use `removeFlag` only when the story explicitly requires forgetting or undoing a condition, and when losing the historical record is acceptable.
