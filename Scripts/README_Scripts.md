# `Scripts/`

This folder contains the core logic of the game in `.gd` files. Scripts are modular and attached to their respective scenes.

## Core Gameplay Logic

- **DungeonGenerator.gd**: Handles procedural generation of rooms, player/enemy spawning, door linking, and layout cleanup.
- **Player.gd**: Player logic including movement, animation, combat, interaction, and death.
- **enemy.gd**: Handles skeleton behavior — chasing, waking up, attacking, and dying.
- **enemy_mage.gd**: Controls the mage enemy — awakening, spellcasting logic, and animations.

## UI & Game States

- **control.gd**: Main menu logic for scene transitions and sound effects.
- **how_to_play.gd**: Manages typewriter effect and back navigation.
- **credits.gd**: Simple script for handling the credits scene and back button.
- **hud.gd**: Health, score tracking, and high score saving/loading.
- **GameOver.gd**: Replay and return to menu functionality.
- **PauseMenu.gd**: Input detection and logic for showing/hiding the pause menu, available from both main menu and the pause menu.

## Systems & Effects

- **Camera.gd**: Third-person camera following the player, including shake effects when damage is taken.
- **LoadingScreen.gd**: Handles fade-in/out transition for the bootsplash on load.
- **mage_spell_effect.gd**: Temporary spell effect with cleanup.
- **potion.gd**: Healing behavior when player interacts with a potion.
- **chest.gd**: Rewards score to player on opening.
- **Flicker.gd**: Applies light flickering to torches using random intensity.

## Settings

- **options_menu.gd**: Adjusts UI sliders and buttons and saves preferences.
- **Settings.gd**: Is an autoload singleton and manages persistent storage of volume/fullscreen/vsync values and applies them.

## Additional Notes

- Most systems rely on groups (like `"player"`, `"doorways"`, `"hud"`) and well-named nodes for referencing in code.
- Comments and docstrings have been added to each script to assist future development.
