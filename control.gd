extends Control


func _ready():
	$StartButton.pressed.connect(_on_start_button_pressed)
	$OptionsButton.pressed.connect(_on_options_button_pressed)
	$ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://DungeonGenerator.tscn")

func _on_options_button_pressed():
	# Loads the options menu
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")

func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()
