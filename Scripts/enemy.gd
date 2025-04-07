extends CharacterBody3D

## --- Enemy Skeleton Script ---
## This enemy remains idle until the player enters its vision range.
## Once awake, it chases and attacks using melee if within range.
## Plays animations and SFX accordingly.

# --- Enemy Stats ---
@export var health: int = 30
@export var chase_speed: float = 2.0
@export var vision_range: float = 10.0
@export var attack_range: float = 2.0
@export var attack_damage: int = 10
@export var attack_cooldown: float = 1.0

# --- AI States ---
enum State { IDLE, CHASING, DEAD }
var current_state: State = State.IDLE
var can_attack: bool = true
var is_awake: bool = false
var is_waking_up: bool = false
var spawn_position: Vector3

# --- References ---
@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent = $NavigationAgent3D
@onready var anim_player = $Skeleton_Minion/AnimationPlayer

# --- SFX ---
@onready var wake_sfx = $WakeSFX
@onready var walk_sfx = $WalkSFX
@onready var death_sfx = $DeathSFX

signal died  # Emitted when the enemy is killed


# --- Initialization ---
func _ready() -> void:
	spawn_position = global_transform.origin
	anim_player.play("Skeletons_Inactive_Floor_Pose")


# --- AI Processing ---
func _physics_process(delta: float) -> void:
	if current_state == State.DEAD or not is_instance_valid(player):
		return

	var player_visible = can_see_player()

	if not is_awake and player_visible:
		await wake_up()

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
		await attack_player()


# --- Wake-Up Sequence ---
func wake_up() -> void:
	if is_awake or is_waking_up:
		return

	is_waking_up = true
	if wake_sfx:
		wake_sfx.play()

	print("Skeleton waking up")
	anim_player.play("Skeletons_Awaken_Floor_Long")
	await anim_player.animation_finished

	anim_player.play("Walking_D_Skeletons")
	is_awake = true
	is_waking_up = false
	current_state = State.CHASING


# --- Chasing Logic ---
func chase_player(delta: float) -> void:
	var distance = global_transform.origin.distance_to(player.global_transform.origin)

	if distance > attack_range:
		move_towards(player.global_transform.origin, chase_speed, delta)

		if walk_sfx and not walk_sfx.playing:
			walk_sfx.play()
	else:
		velocity = Vector3.ZERO
		move_and_slide()

		if walk_sfx and walk_sfx.playing:
			walk_sfx.stop()


# --- Movement Helper ---
func move_towards(target: Vector3, move_speed: float, delta: float) -> void:
	var direction = (target - global_transform.origin).normalized()
	velocity = direction * move_speed
	move_and_slide()

	# Rotate visual mesh to face direction
	if direction.length() > 0.1:
		$Skeleton_Minion.look_at(global_transform.origin + direction, Vector3.UP)
		$Skeleton_Minion.rotate_y(deg_to_rad(180))

	# Restart walk animation if needed
	if is_awake and not anim_player.is_playing():
		anim_player.play("Walking_D_Skeletons")


# --- Detection Helpers ---
func can_see_player() -> bool:
	return is_instance_valid(player) and global_transform.origin.distance_to(player.global_transform.origin) <= vision_range

func is_player_in_range() -> bool:
	return is_instance_valid(player) and global_transform.origin.distance_to(player.global_transform.origin) <= attack_range


# --- Attack Logic ---
func attack_player() -> void:
	if not can_attack or current_state == State.DEAD:
		return

	can_attack = false
	anim_player.play("1H_Melee_Attack_Jump_Chop")

	await anim_player.animation_finished

	if "take_damage" in player:
		player.take_damage(attack_damage)

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


# --- Damage Handling ---
func take_damage(amount: int) -> void:
	if current_state == State.DEAD:
		return

	health -= amount

	if health <= 0:
		await die()


# --- Death Handling ---
func die() -> void:
	if current_state == State.DEAD:
		return

	print("Enemy died!")
	current_state = State.DEAD

	if death_sfx:
		death_sfx.play()

	anim_player.play("Death_C_Skeletons")
	await anim_player.animation_finished

	emit_signal("died")

	# Award points
	var hud = get_tree().get_root().find_child("HUD", true, false)
	if hud:
		hud.add_score(200)

	queue_free()
