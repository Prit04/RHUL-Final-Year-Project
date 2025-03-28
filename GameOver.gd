extends CanvasLayer

@onready var play_again_button = $VBoxContainer/PlayAgainButton
@onready var main_menu_button = $VBoxContainer/MainMenuButton

func _ready():
	visible = false
	play_again_button.pressed.connect(on_play_again_pressed)
	main_menu_button.pressed.connect(on_main_menu_pressed)

func on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()





func on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://control.tscn")  
