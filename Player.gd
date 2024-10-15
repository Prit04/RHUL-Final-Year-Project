extends CharacterBody3D

# Movement variables
var speed = 5.0
var gravity = -9.8  # Optional, for vertical movement

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	# Reset horizontal velocity
	velocity.x = 0
	velocity.z = 0
	
	# Input for WASD or Arrow keys
	var input_dir = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):  # W or Up
		input_dir.z += 1
	if Input.is_action_pressed("move_back"):     # S or Down
		input_dir.z -= 1
	if Input.is_action_pressed("move_left"):     # A or Left
		input_dir.x += 1
	if Input.is_action_pressed("move_right"):    # D or Right
		input_dir.x -= 1

	# Normalize the direction to avoid faster diagonal movement
	if input_dir != Vector3.ZERO:
		input_dir = input_dir.normalized()

	# Apply movement input to velocity
	velocity.x = input_dir.x * speed
	velocity.z = input_dir.z * speed

	# Apply gravity if needed (optional, since top-down games don't always need this)
	velocity.y += gravity * delta

	# Move the player using the built-in move_and_slide() method
	move_and_slide()
