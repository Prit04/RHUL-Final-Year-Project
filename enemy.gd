extends CharacterBody3D

# Enemy attributes
var health = 50
var chase_speed = 3.5
var vision_range = 10.0
var attack_range = 2.0
var attack_damage = 10
var attack_cooldown = 1.0
var can_attack: bool = true
var spawn_position: Vector3


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

	match current_state:
		State.IDLE:
			if can_see_player():
				wake_up()
		State.CHASING:
			chase_player(delta)
			if not can_see_player():
				current_state = State.IDLE  # Go back to idle if player leaves vision

	if is_player_in_range():
		attack_player()

func wake_up():
	if current_state != State.IDLE:
		return
	print("Skeleton waking up!")
	current_state = State.CHASING
	anim_player.play("Skeletons_awaken_Floor_Long")
	await anim_player.animation_finished
	anim_player.play("Walking_D_Skeletons")  # Switch to walking animation

func chase_player(delta: float):
	move_towards(player.global_transform.origin, chase_speed, delta)

func move_towards(target: Vector3, move_speed: float, delta: float):
	var direction = (target - global_transform.origin).normalized()
	velocity = direction * move_speed
	move_and_slide()

	if current_state == State.CHASING and not anim_player.is_playing():
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
