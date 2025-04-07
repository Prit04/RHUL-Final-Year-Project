extends Control

## --- Credits Menu Script ---
## Handles the back button and plays click sound before returning to main menu.

@onready var back_button = $BackButton
@onready var click_player = $ClickPlayer

func _ready():
	# Connect back button 
	if back_button:
		back_button.pressed.connect(_on_back_pressed)


func _on_back_pressed() -> void:
	# Play click sound before returning to main menu
	if click_player:
		click_player.play()
		await click_player.finished

	get_tree().change_scene_to_file("res://Scenes/control.tscn")
