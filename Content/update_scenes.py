import json

# Read the file
with open('chapter1_pack.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# New npc_scholar_thread scene
new_scholar = {
  "id": "npc_scholar_thread",
  "title": "A Quiet Reader",
  "text": [
    "Near a sheltered wall, a scholar stands with a small stack of papers held down by a flat stone.",
    "Their eyes move faster than their hands—careful not to tear the page in the wind."
  ],
  "choices": [
    {
      "text": "Introduce yourself and ask what they're studying.",
      "requires": [
        { "type": "notFlag", "flag": "HUB_PATROLS_TIGHTENED" }
      ],
      "outcomes": [
        {
          "text": [
            "You keep your voice low and your stance unthreatening.",
            "The scholar answers without looking up at first—then finally meets your eyes, measuring, curious."
          ],
          "effects": [
            { "type": "setFlag", "flag": "SCHOLAR_MET" },
            { "type": "practiceSkill", "skill": "LORE", "amount": 1 },
            { "type": "log", "message": "You met a scholar with a taste for careful details." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Introduce yourself and ask what they're studying.",
      "requires": [
        { "type": "hasFlag", "flag": "HUB_PATROLS_TIGHTENED" }
      ],
      "outcomes": [
        {
          "text": [
            "You keep your voice low and your stance unthreatening.",
            "The scholar glances past you twice before answering, words chosen as if someone might be listening."
          ],
          "effects": [
            { "type": "setFlag", "flag": "SCHOLAR_MET" },
            { "type": "practiceSkill", "skill": "LORE", "amount": 1 },
            { "type": "advanceTime", "amount": 1 },
            { "type": "log", "message": "With patrols tightened, even introductions move slower." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Ask for a small, practical tip about the roads beyond town.",
      "requires": [
        { "type": "notFlag", "flag": "HUB_PATROLS_TIGHTENED" }
      ],
      "outcomes": [
        {
          "text": [
            "You keep the question grounded—weather, footing, places to rest.",
            "The scholar points with a fingertip, not a whole hand, tracing routes as if mapping them in the air."
          ],
          "effects": [
            { "type": "setFlag", "flag": "SCHOLAR_OPEN" },
            { "type": "practiceSkill", "skill": "INSIGHT", "amount": 1 },
            { "type": "log", "message": "You picked up a few road-wise details from someone who reads the land like a page." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Ask for a small, practical tip about the roads beyond town.",
      "requires": [
        { "type": "hasFlag", "flag": "HUB_PATROLS_TIGHTENED" }
      ],
      "outcomes": [
        {
          "text": [
            "You keep the question grounded—weather, footing, places to rest.",
            "The scholar hesitates, then offers advice in half-sentences. Their eyes keep tracking movement at the edge of the square."
          ],
          "effects": [
            { "type": "setFlag", "flag": "SCHOLAR_OPEN" },
            { "type": "practiceSkill", "skill": "INSIGHT", "amount": 1 },
            { "type": "fatigue", "amount": 1 },
            { "type": "log", "message": "Under tighter patrols, getting answers takes more care—and more effort." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Offer to steady their papers from the wind.",
      "requires": [
        { "type": "notFlag", "flag": "HUB_PATROLS_TIGHTENED" }
      ],
      "outcomes": [
        {
          "text": [
            "You hold the stack in place with two fingers, careful not to smudge ink.",
            "The scholar's shoulders ease. A quiet trust settles between you, thin but real."
          ],
          "effects": [
            { "type": "setFlag", "flag": "SCHOLAR_IMPRESSED" },
            { "type": "practiceSkill", "skill": "FOCUS", "amount": 1 },
            { "type": "log", "message": "A small, practical kindness earned you regard." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Offer to steady their papers from the wind.",
      "requires": [
        { "type": "hasFlag", "flag": "HUB_PATROLS_TIGHTENED" }
      ],
      "outcomes": [
        {
          "text": [
            "You hold the stack in place with two fingers, careful not to smudge ink.",
            "A passing patrol slows. The scholar freezes until the footsteps move on—then exhales like they've been holding their breath for minutes."
          ],
          "effects": [
            { "type": "setFlag", "flag": "SCHOLAR_IMPRESSED" },
            { "type": "practiceSkill", "skill": "FOCUS", "amount": 1 },
            { "type": "advanceTime", "amount": 1 },
            { "type": "log", "message": "Tightened patrols turn small moments into long ones." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Excuse yourself and leave them to their work.",
      "outcomes": [
        {
          "text": [
            "You step away without forcing conversation.",
            "The scholar returns to the page as if it never stopped moving."
          ],
          "effects": [
            { "type": "log", "message": "You left the scholar undisturbed." }
          ],
          "to": "hub_square"
        }
      ]
    }
  ]
}

# New hub_release_valve scene
new_release_valve = {
  "id": "hub_release_valve",
  "title": "A Quiet Rinse",
  "text": [
    "Behind a row of stalls, a narrow doorway leads to a small washroom—basins, rough towels, and a single bench.",
    "It smells of soap and old steam. The kind of place people use when they don't want questions."
  ],
  "choices": [
    {
      "text": "Rinse, change your look, and leave no trail to follow.",
      "requires": [
        { "type": "hasFlag", "flag": "WILD_OB1_TRAIL_HEAT" },
        { "type": "notFlag", "flag": "HUB_PATROLS_TIGHTENED" }
      ],
      "outcomes": [
        {
          "text": [
            "You scrub dust and sweat from skin and cloth, then step out with your posture reset.",
            "Whatever was clinging to you feels less certain now—harder to read at a glance."
          ],
          "effects": [
            { "type": "removeFlag", "flag": "WILD_OB1_TRAIL_HEAT" },
            { "type": "advanceTime", "amount": 1 },
            { "type": "practiceSkill", "skill": "FOCUS", "amount": 1 },
            { "type": "log", "message": "You took time to reduce the attention your trail might draw." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Rinse, change your look, and leave no trail to follow.",
      "requires": [
        { "type": "hasFlag", "flag": "WILD_OB1_TRAIL_HEAT" },
        { "type": "hasFlag", "flag": "HUB_PATROLS_TIGHTENED" }
      ],
      "outcomes": [
        {
          "text": [
            "You scrub dust and sweat from skin and cloth, then step out with your posture reset.",
            "Outside, footsteps pass twice before you move. Today, privacy takes patience."
          ],
          "effects": [
            { "type": "removeFlag", "flag": "WILD_OB1_TRAIL_HEAT" },
            { "type": "advanceTime", "amount": 1 },
            { "type": "fatigue", "amount": 1 },
            { "type": "practiceSkill", "skill": "FOCUS", "amount": 1 },
            { "type": "log", "message": "You shed your heat, but tightened patrols made it cost more." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Call in a quiet favor to smooth the way out.",
      "requires": [
        { "type": "hasFlag", "flag": "HUB_FAVOR_NOTE" },
        { "type": "notFlag", "flag": "HUB_FAVOR_SPENT" },
        { "type": "hasFlag", "flag": "HUB_WATCHLIST" }
      ],
      "outcomes": [
        {
          "text": [
            "A few words pass through the right mouth at the right time.",
            "Nothing official changes, but the air around you loosens—like someone decided you're not worth the pause."
          ],
          "effects": [
            { "type": "setFlag", "flag": "HUB_FAVOR_SPENT" },
            { "type": "removeFlag", "flag": "HUB_WATCHLIST" },
            { "type": "setFlag", "flag": "HUB_GUARD_SOFTENED" },
            { "type": "advanceTime", "amount": 1 },
            { "type": "log", "message": "You spent a favor to reduce scrutiny—quietly and without a scene." }
          ],
          "to": "hub_square"
        }
      ]
    },
    {
      "text": "Keep your head down and leave as you came.",
      "outcomes": [
        {
          "text": [
            "You don't linger. Some days, the safest choice is to stay unremarkable.",
            "The hub swallows you back into its noise."
          ],
          "effects": [
            { "type": "log", "message": "You chose not to spend time or favors here." }
          ],
          "to": "hub_square"
        }
      ]
    }
  ]
}

# Find and replace/add scenes
scholar_replaced = False
release_valve_exists = False

for i, scene in enumerate(data['scenes']):
    if scene['id'] == 'npc_scholar_thread':
        data['scenes'][i] = new_scholar
        scholar_replaced = True
        print('Replaced npc_scholar_thread')
    elif scene['id'] == 'hub_release_valve':
        data['scenes'][i] = new_release_valve
        release_valve_exists = True
        print('Replaced hub_release_valve')

# Add hub_release_valve if it doesn't exist
if not release_valve_exists:
    data['scenes'].append(new_release_valve)
    print('Added hub_release_valve')

# Write back with nice formatting
with open('chapter1_pack.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f'Total scenes: {len(data["scenes"])}')
print('Done!')
