# Final Year Project
# Cryptborn: Procedural Dungeon Crawler

**Cryptborn** is a 3D action-adventure dungeon crawler built in **Godot 4.3**, featuring procedural room generation, enemy AI, melee combat, dynamic lighting, ambient effects, and an atmospheric retro UI. Your objective: survive the dungeon, collect loot, and avoid the void.
<br> <br> 

## Features

- Procedural dungeon generation (trap rooms, chests, potions)
- Melee combat system with animation-based attacks
- Multiple enemy types: melee skeletons and ranged mages
- Enemy awakening & patrol logic
- Score saving system
- Full sound design 

## How to Play

- **WASD** — Move
- **Shift** — Sprint
- **Space** — Attack
- **E** — Interact with chests or potions
- **ESC** — Pause menu (Options, Resume, Exit)

Get the highest score possible by killing enemies and finding chests filled with loot.
<br> <br>Potions will aid your journey healing any wounds you may acquire.
<br> <br>Avoid the **fog** outside the dungeon. Falling into the void results in death.

## Technical Breakdown

| Feature | Description |
|--------|-------------|
| **Procedural Generation** | Rooms placed via offset-based spawning, snap-to-grid alignment, door linking logic |
| **Enemy AI** | FSM-based logic with range detection, attacks, and death sequences |
| **Audio Settings** | Master/Music/SFX sliders linked to `AudioBus` volumes with config saving |
| **Score System** | Current score, high score saving with file I/O |
| **Scene Transitions** | Smooth fades between menus and gameplay states |
| **Visual FX** | Torch flickering (RNG-based light energy), potion glows, screen shake |

# Running instructions
## Prerequisites
Before running the game, ensure you have the following installed: Godot Engine 4.x

<br> <br> 

## Setting Up the Project
### Using Git:
Open your terminal/command prompt.
Clone the project repository

<br> <br> 

### Without Git:
Download the project as a .zip file from the repository. 
<br> 
Extract the contents to a folder on your system.

<br> <br> 

## Running the Game in Godot
Open the Godot Engine.
<br> 
Click on Import Project and navigate to the folder containing the project files.
<br> 
Select the project.godot file and click Open.
<br> 
Once the project is imported, click Play (F5) in the top-right corner of the Godot editor to run the game.

# Author

**Name:** Prithvi Sathyamoorthy Veeran
<br> 

**Student Number:** 101004017
<br> 

**Candidate Number:** 2503780
<br> 

**Project Type:** Final Year Project — Building a Game  
