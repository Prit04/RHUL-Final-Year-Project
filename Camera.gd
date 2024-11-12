extends Camera3D


@export var target: CharacterBody3D  
@export var height: float = 8.0
@export var distance: float = -8.0
@export var smooth_time: float = 0.1

func _process(delta):
	if target:
		# Calculate the desired position above and behind the player
		var target_position = target.global_position + Vector3(0, height, distance)
		
		# Smoothly interpolate towards the target position
		global_position = global_position.lerp(target_position, smooth_time)
		
		# Look at the target player position
		look_at(target.global_position, Vector3.UP)
