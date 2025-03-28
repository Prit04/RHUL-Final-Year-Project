extends CharacterBody3D

# Movement variables
@export var walk_speed: float = 5.0
@export var run_speed: float = 10.0

var attack_range = 2.0
var attack_damage = 10 

var max_health = 100
var current_health = 100

var is_dead = false

var is_attacking = false


@onready var animation_player = $Knight/AnimationPlayer
@onready var hud = get_tree().get_current_scene().get_node("CanvasLayer/HUD")



func take_damage(damage):
	if is_dead:
		return

	current_health -= damage
	current_health = clamp(current_health, 0, max_health)

	var hearts_to_show = ceil(float(current_health) / 20.0)
	if hud:
		hud.update_health(hearts_to_show, 5)  

	if current_health <= 0:
		die()


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
	var game_over = get_tree().current_scene.get_node("GameOver")
	if game_over:
		game_over.visible = true
	else:
		print("GameOver screen not found!")



func update_health_ui() -> void:
	var hud = get_node_or_null("/root/StaticBody3D/HUD")
	if hud:
		hud.update_health(current_health, max_health)

var can_attack = true
var attack_cooldown = 0.6

func _process(delta):
	if is_dead:
		return

	if Input.is_action_just_pressed("attack") and can_attack:
		is_attacking = true
		perform_attack()
		
	if Input.is_action_just_pressed("interact"):
		var chest = get_interactable_chest()
		if chest:
			print(" Chest found:", chest)
			chest.interact()
		else:
			print(" No chest detected nearby.")
			
func heal(amount: int):
	if is_dead:
		return
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	var hearts_to_show = ceil(float(current_health) / 20.0)
	if hud:
		hud.update_health(hearts_to_show, 5)
	print("Healed! Current HP:", current_health)



func get_interactable_chest():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = SphereShape3D.new()
	query.shape.radius = 2.5  
	query.transform = global_transform
	query.collision_mask = 1 
	var results = space_state.intersect_shape(query)
	print("🔍 Checking for chests. Hits:", results.size())

	for result in results:
		print("Found:", result.collider)
		
		if result.collider.has_method("interact"):
			print(" Interactable chest found!")
			return result.collider

	print(" No chest detected nearby.")
	return null


func perform_attack():
	can_attack = false
	is_attacking = true

	animation_player.stop()
	animation_player.play("1H_Melee_Attack_Slice_Diagonal", -1, 1.0)
	animation_player.seek(0, true)

	# Detect and damage enemies
	var enemies = get_enemies_in_range()
	for enemy in enemies:
		enemy.take_damage(attack_damage)

	# Wait for animation to finish playing
	await animation_player.animation_finished

	
	await get_tree().create_timer(0.2).timeout

	is_attacking = false
	animation_player.play("Idle")  

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true





func attack():
	var enemies_in_range = get_enemies_in_range()
	
	for enemy in enemies_in_range:
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)

func get_enemies_in_range() -> Array:
	var enemies_in_range = []
	var space_state = get_world_3d().direct_space_state

	var sphere = SphereShape3D.new()
	sphere.radius = attack_range

	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = sphere
	query.transform = Transform3D(Basis(), global_transform.origin + transform.basis.z * 1.5) 

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

	if is_dead or is_attacking:
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
