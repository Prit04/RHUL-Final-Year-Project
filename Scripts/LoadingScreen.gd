extends Control

## --- Scene Transition Loader Script ---
## Plays a fade animation and loads the next scene.
## Skips transition early if user inputs (key/mouse).

@export var next_scene: String = "res://Scenes/control.tscn"  # Target scene path

func _ready() -> void:
	$AnimationPlayer.play("fade_in_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(next_scene)

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		get_tree().change_scene_to_file(next_scene)
