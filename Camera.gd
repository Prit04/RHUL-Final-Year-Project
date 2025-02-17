extends Camera3D

@export var target: CharacterBody3D
@export var height: float = 10.0
@export var distance: float = -15.0
@export var zoom_speed: float = 2.0  # Adjust zoom speed
@export var min_distance: float = -25.0  # Max zoom out
@export var max_distance: float = -10.0  # Min zoom in
@export var smooth_time: float = 0.1

func _process(delta):
	if target:
		# Handle Zooming with Mouse Wheel
		if Input.is_action_just_pressed("zoom_in"):
			distance = max(distance + zoom_speed, max_distance)
		if Input.is_action_just_pressed("zoom_out"):
			distance = min(distance - zoom_speed, min_distance)

		var target_position = target.global_position + Vector3(0, height, distance)
		global_position = global_position.lerp(target_position, smooth_time)
		look_at(target.global_position, Vector3.UP)
