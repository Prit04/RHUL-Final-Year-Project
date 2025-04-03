extends CanvasLayer

## --- Pause Menu Script ---
## Handles the pause menu functionality including resume, options, and exit.
## Toggled by the pause key and manages game pause state and UI visibility.


# --- Button Nodes ---
@onready var resume_button = $VBoxContainer/ResumeButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var exit_button = $VBoxContainer/ExitButton

# --- Audio ---
@onready var click_player = $ClickPlayer


func _ready() -> void:
	# Initially hide the pause menu
	visible = false

	# Connect button interactions
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	options_button.pressed.connect(_on_options_pressed)


func _unhandled_input(event: InputEvent) -> void:
	# Checks for pause key to toggle menu
	if event.is_action_pressed("pause"):
		toggle_pause()


func toggle_pause() -> void:
	# Shows or hides the pause menu and pauses the game
	if visible:
		hide()
		get_tree().paused = false
	else:
		show()
		get_tree().paused = true


func _on_resume_pressed() -> void:
	# Resumes the game from pause
	click_player.play()
	toggle_pause()


func _on_exit_pressed() -> void:
	# Returns to main menu, unpauses first
	click_player.play()
	await click_player.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://control.tscn")


func _on_options_pressed() -> void:
	# Opens the options menu from pause
	click_player.play()
	await click_player.finished

	var options_scene = preload("res://OptionsMenu.tscn")
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
