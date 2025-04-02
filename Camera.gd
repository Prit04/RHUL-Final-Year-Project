extends Camera3D

## --- Editor Exports ---
@export var player: Node3D                           # Player node to follow
@export var follow_speed: float = 5.0                # Smoothness of camera movement
@export var camera_height: float = 10.0              # Height above the player
@export var camera_distance: float = 12.0            # Distance behind the player
@export var camera_angle: float = -30.0              # Downward tilt angle (X rotation)

## --- Camera Shake Variables ---
var shake_amount := 0.1
var shake_duration := 0.2
var shake_timer := 0.0
var shake_offset := Vector3.ZERO
var rng := RandomNumberGenerator.new()

## --- Internal State ---
var target_position: Vector3                         # Desired camera position

func _ready():
	if player == null:
		push_error("Player not assigned to Camera3D!")
		return

	rng.randomize()
	rotation_degrees.x = camera_angle  # Tilt camera down at start


func _process(_delta):
	if player == null:
		return

	if shake_timer > 0:
		shake_timer -= _delta
		shake_offset = Vector3(
			rng.randf_range(-shake_amount, shake_amount),
			rng.randf_range(-shake_amount, shake_amount),
			rng.randf_range(-shake_amount, shake_amount)
		)
	else:
		shake_offset = Vector3.ZERO

	update_camera_position(_delta)


func update_camera_position(delta: float) -> void:
	# Desired position: behind and above player
	target_position = player.global_transform.origin + Vector3(0, camera_height, -camera_distance)
	target_position += shake_offset

	# Smooth movement
	global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)

	# Face the player
	look_at(player.global_transform.origin, Vector3.UP)


func shake_camera(amount: float = 1.0, duration: float = 0.2) -> void:
	#Used to show damage feedback 
	shake_amount = amount
	shake_duration = duration
	shake_timer = duration
