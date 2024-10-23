extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.connect("pressed", Callable(self, "_on_StartButton_pressed"))
	$OptionsButton.connect("pressed", Callable(self, "_on_OptionsButton_pressed"))
	$ExitButton.connect("pressed", Callable(self, "_on_ExitButton_pressed"))


func _on_start_button_pressed():
	#Loads the game state screen
	get_tree().change_scene_to_file("res://MainGameEnvironment.tscn")


func _on_options_button_pressed():
		#Loads the options menu
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")


func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()
	
