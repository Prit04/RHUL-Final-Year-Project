extends Camera3D

@export var player: Node3D  # Assign Player in the Inspector
@export var follow_speed: float = 5.0  # Smoothness of camera movement
@export var zoom_speed: float = 2.0  #  Speed of zooming
@export var min_zoom: float = 5.0  # Closest zoom
@export var max_zoom: float = 20.0  # Farthest zoom
@export var camera_height: float = 10.0  #  Height above player
@export var camera_distance: float = 12.0  #  Distance behind player
@export var camera_angle: float = -30.0  # Downward tilt angle 

var zoom_level: float  #  Current zoom level
var shake_amount := 0.1
var shake_duration := 0.2
var shake_timer := 0.0
var rng := RandomNumberGenerator.new()
var shake_offset := Vector3.ZERO


func _ready():
	if player == null:
		print("ERROR: Player node not assigned in Inspector!")
		return
	rng.randomize()
	zoom_level = camera_distance
	rotation_degrees.x = camera_angle
  

func _process(delta):
	if player == null:
		return  # prevent crashes if player is missing

	follow_player(delta)
	handle_zoom(delta)
	
	if shake_timer > 0:
		shake_timer -= delta
		shake_offset = Vector3(
			rng.randf_range(-shake_amount, shake_amount),
			rng.randf_range(-shake_amount, shake_amount),
			rng.randf_range(-shake_amount, shake_amount)
		)
	else:
		shake_offset = Vector3.ZERO


func follow_player(delta):
	# Position the camera behind & above the player
	var target_position = player.global_transform.origin
	target_position += Vector3(0, camera_height, -zoom_level)  # Keep camera behind

	# Smoothly move the camera to follow the player
	global_transform.origin = global_transform.origin.lerp(target_position + shake_offset, follow_speed * delta)


	
	look_at(player.global_transform.origin, Vector3.UP)
	
func shake_camera(amount: float = 1, duration: float = 0.2):
	shake_amount = amount
	shake_duration = duration
	shake_timer = duration

func handle_zoom(delta):
	# Adjust zoom level based on input
	if Input.is_action_pressed("zoom_in"):
		zoom_level -= zoom_speed * delta
	elif Input.is_action_pressed("zoom_out"):
		zoom_level += zoom_speed * delta

	# Clamp zoom to prevent extreme values
	zoom_level = clamp(zoom_level, min_zoom, max_zoom)
