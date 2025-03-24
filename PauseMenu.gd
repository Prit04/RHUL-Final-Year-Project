extends CanvasLayer

@onready var resume_button = $VBoxContainer/ResumeButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var exit_button = $VBoxContainer/ExitButton

func _ready():
	visible = false  # Start hidden
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	options_button.pressed.connect(_on_options_pressed)

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if visible:
		visible = false
		get_tree().paused = false  # Resume game
	else:
		visible = true
		get_tree().paused = true   # Pause game

func _on_resume_pressed():
	toggle_pause()

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Control.tscn")  # Main Menu Scene

func _on_options_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")
