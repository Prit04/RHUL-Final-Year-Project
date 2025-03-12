extends CharacterBody3D

# Movement variables
@export var walk_speed: float = 5.0
@export var run_speed: float = 10.0

var attack_range = 2.0
var attack_damage = 10 

var max_health = 100
var current_health = 100

var is_dead = false

@onready var animation_player = $Knight/AnimationPlayer

func take_damage(damage):
	if is_dead:
		return
	current_health -= damage
	if current_health <= 0:
		die()
	else:
		update_health_ui()

func die():
	if is_dead:
		return
	is_dead = true
	animation_player.play("Death_B")
	print("The player has died")
	
	var hud = get_node_or_null("/root/StaticBody3D/HUD")
	if hud:
		hud.visible = false
		show_game_over()

func show_game_over():
	var game_over_scene = load("res://GameOver.tscn")  
	var game_over_instance = game_over_scene.instantiate()
	get_tree().current_scene.add_child(game_over_instance)


func update_health_ui() -> void:
	var hud = get_node_or_null("/root/StaticBody3D/HUD")
	if hud:
		hud.update_health(current_health, max_health)

func _process(delta):
	if is_dead:
		return

	if Input.is_action_just_pressed("attack"):
		print(" Attack button (Space) pressed!")  # Debug
		attack()

		animation_player.stop()
		animation_player.play("1H_Melee_Attack_Slice_Diagonal", -1, 1.5)
		animation_player.seek(0, true)  # Force restart from frame 0, still broken
		print(" Playing attack animation: 1H_Melee_Attack_Slice_Diagonal")



func attack():
	var enemies_in_range = get_enemies_in_range()
	
	for enemy in enemies_in_range:
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)

func get_enemies_in_range() -> Array:
	var enemies_in_range = []
	var space_state = get_world_3d().direct_space_state

	# Create a shape for the query (Sphere for melee attack range)
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = SphereShape3D.new()
	query.shape.radius = attack_range
	query.transform = global_transform


	query.collision_mask = 2  # Set this to enemy collision layer when it comes to it (check project settings)

	var result = space_state.intersect_shape(query)

	for hit in result:
		if hit.collider != self and hit.collider.has_method("take_damage"):
			enemies_in_range.append(hit.collider)

	return enemies_in_range




func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	if is_dead:
		return

	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		input_dir.z += 1
	if Input.is_action_pressed("move_back"):     
		input_dir.z -= 1
	if Input.is_action_pressed("move_left"):  
		input_dir.x += 1
	if Input.is_action_pressed("move_right"):   
		input_dir.x -= 1


	# Normalize movement to avoid diagonal speed boost
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()

		# Check if sprinting
		var current_speed = walk_speed
		if Input.is_action_pressed("sprint"): 
			current_speed = run_speed

		# Convert movement direction into rotation
		var target_rotation_y = atan2(input_dir.x, input_dir.z)
		rotation.y = lerp_angle(rotation.y, target_rotation_y, 10.0 * delta)

		# Apply movement speed
		velocity.x = input_dir.x * current_speed
		velocity.z = input_dir.z * current_speed
	else:
		#Stop the player when no input is detected
		velocity = Vector3.ZERO  

	move_and_slide()

	# Play correct animation
	update_animation(input_dir)


	
func update_animation(input_dir):
	if is_dead:
		return

	if input_dir.length() > 0:
		var is_sprinting = Input.is_action_pressed("sprint")

		#  Choose correct animation based on sprinting or walking
		if is_sprinting:
			if animation_player.current_animation != "Running_A":
				animation_player.play("Running_A")  #  Sprinting forward
		else:
			if animation_player.current_animation != "Walking_A":
				animation_player.play("Walking_A")  #  Normal walking
	else:
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")  #  Idle animation when not moving
