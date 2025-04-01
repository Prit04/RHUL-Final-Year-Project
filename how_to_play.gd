extends Control

@onready var back_button = $BackButton
@onready var click_player = $ClickPlayer  

func _ready():
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	if click_player:
		click_player.play()
		await click_player.finished
	get_tree().change_scene_to_file("res://control.tscn")  
