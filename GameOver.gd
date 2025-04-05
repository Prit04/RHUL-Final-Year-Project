extends CanvasLayer

## --- Game Over Scene Script ---
## Shows the death screen to the player: including return to main menu and retry.

# --- UI Node References ---
@onready var play_again_button = $VBoxContainer/PlayAgainButton
@onready var main_menu_button = $VBoxContainer/MainMenuButton
@onready var click_player = $ClickPlayer


func _ready() -> void:
	visible = false  # Initially hidden, shown on player death
	play_again_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


# --- Retry the current level ---
func _on_play_again_pressed() -> void:
	click_player.play()
	await click_player.finished
	get_tree().paused = false
	get_tree().reload_current_scene()


# --- Return to the main menu ---
func _on_main_menu_pressed() -> void:
	click_player.play()
	await click_player.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://control.tscn")
