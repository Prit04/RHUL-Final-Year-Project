extends Control
@onready var click_player = $ClickPlayer


func _ready():
	$MenuAnimationPlayer.play("BG_fade_in")
	await $MenuAnimationPlayer.animation_finished
	if $MenuAnimationPlayer.has_animation("fade_in"):
		$MenuAnimationPlayer.play("fade_in")

	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(_on_options_button_pressed)
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	click_player.play()
	await click_player.finished
	$MenuAnimationPlayer.play("BG_fade_out")
	await $MenuAnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://DungeonGenerator.tscn")



func _on_options_button_pressed():
	click_player.play()
	await click_player.finished
	$MenuAnimationPlayer.play("BG_fade_out")
	await $MenuAnimationPlayer.animation_finished

	var options_scene = preload("res://OptionsMenu.tscn")
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	$MenuAnimationPlayer.play("BG_fade_in")
	await $MenuAnimationPlayer.animation_finished
	if $MenuAnimationPlayer.has_animation("fade_in"):
		$MenuAnimationPlayer.play("fade_in")

func _on_exit_button_pressed():
	click_player.play()
	await $ClickPlayer.finished
	get_tree().quit()
