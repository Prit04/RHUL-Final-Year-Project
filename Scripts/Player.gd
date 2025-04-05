extends CharacterBody3D

## --- Player Script ---
## Controls movement, combat, interaction, health, and death logic for the player.

# --- Movement Variables ---
@export var walk_speed: float = 5.0
@export var run_speed: float = 10.0
@export var gravity := 9.8
@export var terminal_velocity := 30.0

# --- Combat Variables ---
@export var attack_range := 2.0
@export var attack_damage := 10
@export var attack_cooldown := 0.6

# --- Health ---
var max_health := 100
var current_health := 100
var is_dead := false

# --- State Flags ---
var is_attacking := false
var can_attack := true
var is_interacting := false

# --- Nodes ---
@onready var animation_player = $Knight/AnimationPlayer
@onready var footstep_player = $FootstepPlayer
@onready var hud = get_tree().get_current_scene().get_node("CanvasLayer/HUD")

# --- Damage and Death ---
func take_damage(amount: int) -> void:
	if is_dead:
		return

	current_health = clamp(current_health - amount, 0, max_health)
	var hearts_to_show = ceil(float(current_health) / 20.0)
	if hud:
		hud.update_health(hearts_to_show, 5)

	var camera = get_tree().get_root().find_child("Camera3D", true, false)
	if camera and camera.has_method("shake_camera"):
		camera.shake_camera()

	if current_health <= 0:
		die()


func die() -> void:
	if is_dead:
		return

	is_dead = true
	$DeathSFX.play()
	animation_player.play("Death_B")

	if hud:
		hud.save_score()
		await get_tree().create_timer(0.1).timeout
		hud.visible = false

	show_game_over()


func heal(amount: int) -> void:
	if is_dead:
		return

	current_health = clamp(current_health + amount, 0, max_health)
	var hearts_to_show = ceil(float(current_health) / 20.0)
	if hud:
		hud.update_health(hearts_to_show, 5)


func show_game_over() -> void:
	var game_over = get_tree().current_scene.get_node("GameOver")
	if game_over:
		game_over.visible = true


# --- Input Handling ---
func _process(_delta):
	if is_dead:
		return

	if Input.is_action_just_pressed("attack") and can_attack:
		perform_attack()

	if Input.is_action_just_pressed("interact") and not is_interacting:
		var chest = get_interactable_chest()
		if chest:
			is_interacting = true
			animation_player.stop()
			animation_player.play("Interact")
			animation_player.seek(0, true)

			await animation_player.animation_finished
			chest.interact()
			is_interacting = false

# --- Movement + Physics ---
func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		velocity.y = clamp(velocity.y, -terminal_velocity, terminal_velocity)
	else:
		velocity.y = 0

	# Fall check (void)
	if global_transform.origin.y < -5.0 and not is_dead:
		take_damage(9999)

	handle_movement(delta)


func handle_movement(delta: float) -> void:
	if is_dead:
		return

	var input_dir := Vector3.ZERO

	# Movement input
	if Input.is_action_pressed("move_forward"): input_dir.z += 1
	if Input.is_action_pressed("move_back"):    input_dir.z -= 1
	if Input.is_action_pressed("move_left"):    input_dir.x += 1
	if Input.is_action_pressed("move_right"):   input_dir.x -= 1

	# Normalize to prevent faster diagonal movement
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
		var current_speed := walk_speed
		var target_pitch := 1.0

		if Input.is_action_pressed("sprint"):
			current_speed = run_speed
			target_pitch = 1.5

		# Footstep SFX
		if not footstep_player.playing:
			footstep_player.pitch_scale = target_pitch
			footstep_player.play()
		else:
			footstep_player.pitch_scale = target_pitch

		# Rotation
		var target_rotation_y = atan2(input_dir.x, input_dir.z)
		rotation.y = lerp_angle(rotation.y, target_rotation_y, 10.0 * delta)

		# Velocity
		velocity.x = input_dir.x * current_speed
		velocity.z = input_dir.z * current_speed
	else:
		velocity = Vector3.ZERO
		if footstep_player.playing:
			footstep_player.stop()

	move_and_slide()
	update_animation(input_dir)

# --- Animation ---
func update_animation(input_dir: Vector3) -> void:
	if is_dead or is_attacking or is_interacting:
		return

	if input_dir.length() > 0:
		var is_sprinting = Input.is_action_pressed("sprint")
		var anim = "Running_A" if is_sprinting else "Walking_A"

		if animation_player.current_animation != anim:
			animation_player.play(anim)
	else:
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")

# --- Combat ---
func perform_attack() -> void:
	can_attack = false
	is_attacking = true

	await get_tree().create_timer(0.35).timeout
	$SlashSound.play()
	animation_player.stop()
	animation_player.play("1H_Melee_Attack_Slice_Diagonal", -1, 1.0)
	animation_player.seek(0, true)

	var enemies = get_enemies_in_range()
	for enemy in enemies:
		enemy.take_damage(attack_damage)

	await animation_player.animation_finished
	await get_tree().create_timer(0.2).timeout

	is_attacking = false
	animation_player.play("Idle")
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


func get_enemies_in_range() -> Array:
	var enemies := []
	var space_state = get_world_3d().direct_space_state

	var query := PhysicsShapeQueryParameters3D.new()
	var shape := SphereShape3D.new()
	shape.radius = attack_range
	query.shape = shape
	query.transform = Transform3D(Basis(), global_transform.origin + transform.basis.z * 1.5)

	var result = space_state.intersect_shape(query)
	for hit in result:
		if hit.collider != self and hit.collider.has_method("take_damage"):
			enemies.append(hit.collider)

	return enemies

# --- Chest Interaction ---
func get_interactable_chest():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = SphereShape3D.new()
	query.shape.radius = 2.5
	query.transform = global_transform
	query.collision_mask = 1 

	var results = space_state.intersect_shape(query)
	for result in results:
		if result.collider.has_method("interact"):
			return result.collider

	return null
