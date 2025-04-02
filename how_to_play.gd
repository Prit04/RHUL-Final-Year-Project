extends Control

@onready var back_button = $BackButton
@onready var click_player = $ClickPlayer  
@onready var type_sfx = $TypeSFX
@onready var label = $WARNING

@export var full_text: String = "WARNING:\n
The crypt holds many mysteries, stay confined to the dungeon walls. Do NOT let the fog consume you! It will do what it can to allure you. Ask yourself, is it worth it..."
@export var type_speed: float = 0.05  


func start_typing():
	label.visible_characters = 0
	label.text = full_text
	type_sfx.play() 
	typing_text()

func typing_text():
	for i in range(full_text.length()):
		label.visible_characters = i + 1
		await get_tree().create_timer(type_speed).timeout
	
	type_sfx.stop()  

func _ready():
	start_typing()
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	if click_player:
		click_player.play()
		await click_player.finished
	get_tree().change_scene_to_file("res://control.tscn")  
