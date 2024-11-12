extends CharacterBody3D

# Movement variables
var speed = 5.0
var gravity = -9.8  # Optional, for vertical movement

var attack_range = 2.0
var attack_damage = 10 

var max_health = 100
var current_health = 100

var is_dead = false

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
	print("player has died.")
	
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
		attack()

func attack():
	var enemies_in_range = get_enemies_in_range()
	
	for enemy in enemies_in_range:
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)

func get_enemies_in_range() -> Array:
	var enemies_in_range = []
	var space_state = get_world_3d().direct_space_state
	
	# Create a shape for the query (a sphere for melee range detection)
	var shape = SphereShape3D.new()
	shape.radius = attack_range  # Set the radius of the sphere
	
	# Create the query parameters
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape_rid = shape.get_rid()  # Use the RID of the shape
	query.transform = global_transform  # Use the player's global transform to place the sphere
	query.collision_mask = 1 
	
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
	# Reset horizontal velocity
	velocity.x = 0
	velocity.z = 0
	

	var input_dir = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_dir.z += 1
	if Input.is_action_pressed("move_back"):     
		input_dir.z -= 1
	if Input.is_action_pressed("move_left"):  
		input_dir.x += 1
	if Input.is_action_pressed("move_right"):   
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
