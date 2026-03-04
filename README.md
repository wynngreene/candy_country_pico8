# 🍬 Candy Country (Pico-8)

**Candy Country** is a retro action RPG built with the **Pico-8 fantasy console**.

You play as the **Protector of the Candy Forest**, defending magical candy creatures from poachers who capture them to sell to merchants across the land.

Your mission is simple:

**Rescue the creatures. Defeat the poachers. Protect the forest.**

---

# 🎮 Controls

| Button | Action          |
| ------ | --------------- |
| ⬅️➡️   | Move            |
| 🅾️    | Jump / Interact |
| ❌      | Attack          |

**Interactions**

* Attack poachers to defeat them
* Stand near a cage and press **🅾️** to free a candy creature
* Collect dropped **commodities**

---

# 🕹 Gameplay

* Explore the **Candy Forest**
* Defeat **Poachers**
* Free **Candy Creatures**
* Collect **Commodities**
* Clear the forest to win

Inspired by **Zelda II (NES)** style movement and combat.

---

# 🛠 Development

This project uses **Pico-8** with a modular workflow using `#include`.

Instead of putting all code inside the cartridge tabs, the game is organized into separate Lua files for easier development and Git tracking.

---

# 📁 Project Structure

```
candy_country_pico8/
│
├─ candy_forest.p8     # main cartridge loader
│
├─ main.lua            # game loop
├─ world.lua           # map + camera
├─ player.lua          # player movement + combat
├─ poacher.lua         # enemy AI
├─ cages.lua           # creature cages
├─ drops.lua           # commodities + item drops
├─ ui.lua              # HUD + menus
└─ utils.lua           # helper functions
```

---

# ▶ Running the Game

Open Pico-8 and run:

```
cd candy_country_pico8
load candy_forest.p8
run
```

---

# 🌍 Project Vision

Candy Country begins as a small **Pico-8 adventure demo**, but may grow into a larger world with:

* more forest regions
* silly candy monsters
* collectible candy creatures
* NPC characters
* expanded exploration

---

# ✨ Credits

Created by **Wynn G.**

Built with the **Pico-8 Fantasy Console**

https://www.lexaloffle.com/pico-8.php
