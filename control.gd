extends Control

func _ready():
	if $MenuAnimationPlayer.has_animation("fade_in"):
		$MenuAnimationPlayer.play("fade_in")

	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(_on_options_button_pressed)
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://DungeonGenerator.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
