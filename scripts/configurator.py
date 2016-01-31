#!/usr/bin/env python

import yaml

if __name__ == "__main__":
    # Just testing if YAML loads as part of the framework now
    yy = yaml.load("""
    name: Vorlin Laruknuzum
    sex: Male
    class: Priest
    title: Acolyte
    hp: [32, 71]
    sp: [1, 13]
    gold: 423
    inventory:
      - a Holy Book of Prayers (Words of Wisdom)
      - an Azure Potion of Cure Light Wounds
      - a Silver Wand of Wonder
    """)

    print(yy)

    print yaml.dump({'name': "The Cloak 'Colluin'", 'depth': 5, 'rarity': 45, 'weight': 10, 'cost': 50000, 'flags': ['INT', 'WIS', 'SPEED', 'STEALTH']})
