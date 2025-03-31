extends CanvasLayer

@onready var resume_button = $VBoxContainer/ResumeButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var exit_button = $VBoxContainer/ExitButton
@onready var click_player = $ClickPlayer

func _ready():
	visible = false  # Start hidden
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	options_button.pressed.connect(_on_options_pressed)

func _unhandled_input(event):  
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if visible:
		hide()
		get_tree().paused = false
	else:
		show()
		get_tree().paused = true

func _on_resume_pressed():
	click_player.play()
	toggle_pause()

func _on_exit_pressed():
	click_player.play()
	await $ClickPlayer.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://control.tscn")

func _on_options_pressed():
	click_player.play()
	await click_player.finished

	var options_scene = preload("res://OptionsMenu.tscn")
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
