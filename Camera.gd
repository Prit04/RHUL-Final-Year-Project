extends Camera3D

# Camera follows the player

@export var target: CharacterBody3D # The target the camera will follow
@export var height: float = 8.0 # The hesight of the camera behind the target
@export var distance: float = -8.0 # Distance of the camera from the target
@export var smooth_time: float = 0.1 # The time factor for smooth interpolation

func _process(delta):
	if target:
		# Calculate the desired position above and behind the player
		var target_position = target.global_position + Vector3(0, height, distance)
		
		# Smoothly interpolate towards the target position
		global_position = global_position.lerp(target_position, smooth_time)
		
		# Oritents the camera to to look at the target
		look_at(target.global_position, Vector3.UP)
