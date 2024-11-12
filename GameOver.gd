extends Control

func _ready():
	# Connect button signals
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_button_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_button_pressed)

func _on_restart_button_pressed():
	# Reload the current scene to restart the game
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()
