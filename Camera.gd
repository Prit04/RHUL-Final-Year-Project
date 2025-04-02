extends Camera3D

## --- Camera Follow & Shake Script ---
## Follows the player smoothly and adds screen shake when triggered.

# --- Editor Exports ---
@export var player: Node3D                          # Reference to the player to follow
@export var follow_speed: float = 5.0               # How fast the camera follows
@export var camera_height: float = 10.0             # Height offset from player
@export var camera_distance: float = 12.0           # Distance behind the player
@export var camera_angle: float = -30.0             # Tilt angle (X rotation)

# --- Camera Shake Variables ---
var shake_amount := 0.1
var shake_duration := 0.2
var shake_timer := 0.0
var shake_offset := Vector3.ZERO
var rng := RandomNumberGenerator.new()

# --- Internal State ---
var target_position: Vector3 = Vector3.ZERO         # Desired camera

func _ready():
	if player == null:
		push_error("🚫 Camera3D: Player not assigned!")
		return

	rng.randomize()
	rotation_degrees.x = camera_angle  # Tilt camera down at start


func _process(delta):
	if player == null:
		return

	# Apply screen shake offset if active
	if shake_timer > 0:
		shake_timer -= delta
		shake_offset = Vector3(
			rng.randf_range(-shake_amount, shake_amount),
			rng.randf_range(-shake_amount, shake_amount),
			rng.randf_range(-shake_amount, shake_amount)
		)
	else:
		shake_offset = Vector3.ZERO

	update_camera_position(delta)


func update_camera_position(delta: float) -> void:
	# Calculate desired position behind and above the player
	target_position = player.global_transform.origin
	target_position += Vector3(0, camera_height, -camera_distance) + shake_offset

	# Lerp for smooth motion
	global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)

	# Always face the player
	look_at(player.global_transform.origin, Vector3.UP)


func shake_camera(amount: float = 1.0, duration: float = 0.2) -> void:
	# Triggers a short camera shake effect on damage
	shake_amount = amount
	shake_duration = duration
	shake_timer = duration
