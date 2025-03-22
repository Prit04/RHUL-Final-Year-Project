extends CharacterBody3D

# Enemy attributes
var health = 30
var chase_speed = 2.0
var vision_range = 10.0
var attack_range = 2.0
var attack_damage = 10
var attack_cooldown = 1.0
var can_attack: bool = true
var spawn_position: Vector3
var is_awake: bool = false
var is_waking_up = false 


# Behavior
enum State { IDLE, CHASING, DEAD }
var current_state = State.IDLE

# References
@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent = $NavigationAgent3D
@onready var anim_player = $Skeleton_Minion/AnimationPlayer

signal died  # Signal when the enemy dies

func _ready():
	spawn_position = global_transform.origin
	anim_player.play("Skeletons_Inactive_Floor_Pose")  # Start in idle floor pose

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD or not is_instance_valid(player):
		return

	var player_visible = can_see_player()

	if not is_awake and player_visible:
		wake_up()

	if is_awake:
		if player_visible:
			if current_state != State.CHASING:
				anim_player.play("Walking_D_Skeletons")
				current_state = State.CHASING
		else:
			if current_state != State.IDLE:
				anim_player.play("Idle_Combat")  
				current_state = State.IDLE

	if current_state == State.CHASING:
		chase_player(delta)

	if is_awake and is_player_in_range():
		attack_player()


func wake_up():
	if is_awake or is_waking_up:
		print("Already awake or waking")
		return
	
	print("Skeleton waking up")
	is_waking_up = true
	anim_player.play("Skeletons_Awaken_Floor_Long")

	await anim_player.animation_finished
	
	is_awake = true
	is_waking_up = false
	anim_player.play("Walking_D_Skeletons")
	current_state = State.CHASING



func chase_player(delta: float):
	var distance = global_transform.origin.distance_to(player.global_transform.origin)

	# Only move if the player is NOT within attack range
	if distance > attack_range:
		move_towards(player.global_transform.origin, chase_speed, delta)
	else:
		velocity = Vector3.ZERO
		move_and_slide()


func move_towards(target: Vector3, move_speed: float, delta: float):
	var direction = (target - global_transform.origin).normalized()
	velocity = direction * move_speed
	move_and_slide()

	# Face direction of movement
	if direction.length() > 0.1:
		$Skeleton_Minion.look_at(global_transform.origin + direction, Vector3.UP)
		$Skeleton_Minion.rotate_y(deg_to_rad(180))


	if is_awake and not anim_player.is_playing():
		anim_player.play("Walking_D_Skeletons")


func can_see_player() -> bool:
	if not is_instance_valid(player):
		return false
	return global_transform.origin.distance_to(player.global_transform.origin) <= vision_range

func is_player_in_range() -> bool:
	return is_instance_valid(player) and global_transform.origin.distance_to(player.global_transform.origin) <= attack_range

func attack_player():
	if not can_attack or current_state == State.DEAD:
		return

	can_attack = false
	print("Enemy attacks player!")

	# Play the attack animation
	anim_player.play("1H_Melee_Attack_Jump_Chop")

	# Wait for animation to finish before dealing damage
	await anim_player.animation_finished

	if "take_damage" in player:
		player.take_damage(attack_damage)

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


func take_damage(amount):
	if current_state == State.DEAD:
		return
	health -= amount
	print("Enemy took", amount, "damage. Remaining health:", health)
	if health <= 0:
		die()

func die():
	if current_state == State.DEAD:
		return
	print("Enemy died!")
	current_state = State.DEAD
	anim_player.play("Death_C_Skeletons")
	await anim_player.animation_finished
	emit_signal("died")
	queue_free()
