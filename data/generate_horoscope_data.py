# ChatGPT generated file
# Purpose: Create horoscope data files for daily, monthly, and yearly horoscopes for 2025.
# Used these generated files instead of calling prebuilt API to avoid rate limits and costs.
# Each horoscope includes various fields like general advice, love, career, money, mood, lucky
# number, lucky color, and compatibility.

# Files created:
# - /mnt/data/horoscope_daily_2025.json
# - /mnt/data/horoscope_monthly_2025.json
# - /mnt/data/horoscope_yearly_2025.json

import json
from datetime import date, timedelta

start = date(2025, 1, 1)
end   = date(2025, 12, 31)

SIGNS = [
    "aries","taurus","gemini","cancer","leo","virgo",
    "libra","scorpio","sagittarius","capricorn","aquarius","pisces"
]

# Utility: rotating variations so entries don't look identical
general_variants = [
    "Focus on one meaningful task and protect your attention.",
    "Small, steady steps compound—avoid unnecessary complexity.",
    "Conversations spark ideas—capture insights before they fade.",
    "Follow your intuition; set clear boundaries around your energy.",
    "Bold action works best when you prepare the details first."
]
love_variants = [
    "Lead with curiosity and listen fully.",
    "Tiny acts of care create momentum.",
    "Speak plainly; avoid mixed signals.",
    "Share expectations early; keep it kind.",
    "Reconnect through a shared ritual."
]
career_variants = [
    "Clarify the outcome before you start.",
    "Ship the smallest valuable version today.",
    "Automate one repetitive task.",
    "Ask for feedback earlier than usual.",
    "Document decisions to reduce rework."
]
money_variants = [
    "Stick to plan; skip impulse buys.",
    "Compare options; choose durable value.",
    "Review subscriptions and trim waste.",
    "Budget a buffer for surprises.",
    "Invest in tools that save time."
]
mood_cycle = ["Grounded","Motivated","Curious","Reflective","Focused"]

colors = ["Blue","Green","Gold","Silver","Indigo","Crimson","Teal","Amber","Violet","Coral","Olive","Turquoise"]
compat_cycle = ["Libra","Pisces","Aries","Taurus","Cancer","Virgo","Scorpio","Sagittarius","Capricorn","Aquarius"]

# Build DAILY timeseries (list of days; each day has all signs)
daily_series = []
cur = start
day_index = 0
while cur <= end:
    day_entry = {"date": cur.isoformat(), "signs": {}}
    for i, sign in enumerate(SIGNS):
        day_entry["signs"][sign] = {
            "sign": sign,
            "date": cur.isoformat(),
            "general": general_variants[(day_index + i) % len(general_variants)],
            "love": love_variants[(day_index + 2*i) % len(love_variants)],
            "career": career_variants[(day_index + 3*i) % len(career_variants)],
            "money": money_variants[(day_index + 4*i) % len(money_variants)],
            "mood": mood_cycle[(day_index + i) % len(mood_cycle)],
            "lucky_number": ((day_index + i) % 9) + 1,
            "lucky_color": colors[i],
            "compatibility": compat_cycle[(day_index + i) % len(compat_cycle)]
        }
    daily_series.append(day_entry)
    cur += timedelta(days=1)
    day_index += 1

# Build MONTHLY summaries for Jan..Dec 2025
month_labels = [
    ("2025-01","January"), ("2025-02","February"), ("2025-03","March"), ("2025-04","April"),
    ("2025-05","May"), ("2025-06","June"), ("2025-07","July"), ("2025-08","August"),
    ("2025-09","September"), ("2025-10","October"), ("2025-11","November"), ("2025-12","December")
]
monthly = {"months": []}
for m_idx, (ym, mname) in enumerate(month_labels):
    m_block = {"month": ym, "signs": {}}
    for i, sign in enumerate(SIGNS):
        m_block["signs"][sign] = {
            "sign": sign,
            "month": ym,
            "overview": f"{mname} theme: simplify inputs, improve outputs.",
            "themes": ["discipline","clarity","health"] if m_idx % 2 == 0 else ["relationships","focus","learning"],
            "advice": "Batch similar tasks; protect your deep‑work windows.",
            "key_dates": [
                {"date": f"{ym}-05", "note": "Clear communication aligns plans."},
                {"date": f"{ym}-17", "note": "A workflow tweak pays off."},
                {"date": f"{ym}-28", "note": "Rest and review; let ideas settle."}
            ],
            "focus": ["health","productivity","relationships","learning"][ (i + m_idx) % 4 ]
        }
    monthly["months"].append(m_block)

# Build YEARLY roll‑up for 2025
yearly = {
    "year": 2025,
    "signs": {
        sign: {
            "sign": sign,
            "year": 2025,
            "overview": "A year of consolidation: fewer priorities, better results.",
            "love": "Quality time and honest check‑ins strengthen bonds.",
            "career": "Skill stacking + consistent systems beat spurts of effort.",
            "money": "Prioritize durable value; steady budgeting wins.",
            "health": "Light, daily movement and good sleep hygiene.",
            "opportunities": ["mentorship","process automation","collaboration"],
            "challenges": ["overcommitting","context switching"],
            "lucky_numbers": [3, 11, 17],
            "lucky_months": ["March","July","November"]
        } for sign in SIGNS
    }
}

# Write files
paths = {
    "daily": "/mnt/data/horoscope_daily_2025.json",
    "monthly": "/mnt/data/horoscope_monthly_2025.json",
    "yearly": "/mnt/data/horoscope_yearly_2025.json",
}
with open(paths["daily"], "w") as f:
    json.dump({"range": {"start": start.isoformat(), "end": end.isoformat()}, "days": daily_series}, f, indent=2, ensure_ascii=False)
with open(paths["monthly"], "w") as f:
    json.dump(monthly, f, indent=2, ensure_ascii=False)
with open(paths["yearly"], "w") as f:
    json.dump(yearly, f, indent=2, ensure_ascii=False)

paths
