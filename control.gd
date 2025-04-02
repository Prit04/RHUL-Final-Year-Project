extends Control

## --- Main Menu Script ---
## Handles button interactions, transition animations, and scene changes.

@onready var click_player = $ClickPlayer
@onready var menu_anim = $MenuAnimationPlayer
@onready var start_btn = $VBoxContainer/StartButton
@onready var options_btn = $VBoxContainer/OptionsButton
@onready var exit_btn = $VBoxContainer/ExitButton
@onready var htp_btn = $VBoxContainer/HTPButton
@onready var credits_btn = $VBoxContainer/CreditsButton

func _ready():
	# Play initial background fade-in
	menu_anim.play("BG_fade_in")
	await menu_anim.animation_finished

	if menu_anim.has_animation("fade_in"):
		menu_anim.play("fade_in")

	# Connect all button signals
	start_btn.pressed.connect(_on_start_button_pressed)
	options_btn.pressed.connect(_on_options_button_pressed)
	exit_btn.pressed.connect(_on_exit_button_pressed)
	htp_btn.pressed.connect(_on_HTP_button_pressed)
	credits_btn.pressed.connect(_on_credits_button_pressed)


func _on_start_button_pressed():
	_play_click_and_transition("res://DungeonGenerator.tscn")


func _on_HTP_button_pressed():
	_play_click_and_transition("res://HowToPlay.tscn")


func _on_credits_button_pressed():
	_play_click_and_transition("res://credits.tscn")


func _on_options_button_pressed():
	click_player.play()
	await click_player.finished

	menu_anim.play("BG_fade_out")
	await menu_anim.animation_finished

	var options_scene = preload("res://OptionsMenu.tscn")
	var options_instance = options_scene.instantiate()
	add_child(options_instance)

	# Bring menu background back after options overlay
	menu_anim.play("BG_fade_in")
	await menu_anim.animation_finished
	if menu_anim.has_animation("fade_in"):
		menu_anim.play("fade_in")


func _on_exit_button_pressed():
	click_player.play()
	await click_player.finished
	get_tree().quit()


## Utility to streamline transitions
func _play_click_and_transition(scene_path: String) -> void:
	click_player.play()
	await click_player.finished

	menu_anim.play("BG_fade_out")
	await menu_anim.animation_finished

	get_tree().change_scene_to_file(scene_path)
