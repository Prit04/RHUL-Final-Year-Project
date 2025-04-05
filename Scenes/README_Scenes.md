# `Scenes/`

This folder contains all of the `.tscn` files representing different gameplay elements, UI screens, and environmental pieces used in the game.

## Key Scenes:

- **Chest.tscn**: Scene representing the in-game chest which the player can interact with to gain score.
- **control.tscn**: The main menu scene with options to start the game, access options and how-to-play, and quit.
- **credits.tscn**: Scene for displaying credits and asset attributions.
- **DungeonGenerator.tscn**: Main game logic entry point. Responsible for procedural dungeon generation, enemy placement, and room linking.
- **dungeonRoom.tscn / room_trap.tscn**: Templates for normal and trap dungeon rooms.
- **enemy.tscn / EnemyMage.tscn**: Skeleton and mage enemy units with their models and behavior logic.
- **GameOver.tscn**: UI displayed when the player dies, offering replay or exit.
- **HowToPlay.tscn**: Scene explaining game controls and mechanics.
- **hud.tscn**: The main UI overlay for score, health, etc.
- **LoadingScreen.tscn**: Main bootup splash for the game, leads to the main menu.
- **MageSpellEffect.tscn**: Simple visual effect instantiated during mage attacks.
- **OptionsMenu.tscn**: UI for adjusting volume, fullscreen, and vsync settings.
- **PauseMenu.tscn**: Pause menu with resume, options, and exit buttons.
- **player.tscn**: The player's character and setup.
- **potion.tscn**: Healing item for restoring health.
- **StyledButton.tscn**: A reusable button UI component with custom visuals.

