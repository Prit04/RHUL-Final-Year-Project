extends Control

@export var next_scene: String = "res://control.tscn"  

func _ready():
	# Play the fade-in and fade-out animation
	$AnimationPlayer.play("fade_in_out")

	# Wait for animation to complete, then switch scenes
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(next_scene)

# Skip loading screen if the player presses any key
func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		get_tree().change_scene_to_file(next_scene)
