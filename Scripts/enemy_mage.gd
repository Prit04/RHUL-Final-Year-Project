extends CharacterBody3D

## --- Mage Enemy Script ---
## Handles roaming AI, spellcasting when in range, and wake-up logic for a ranged enemy.
## Uses AnimationPlayer, VFX, SFX, and damage logic.

# --- Enemy Stats ---
@export var chase_speed: float = 2.0
@export var vision_range: float = 10.0
@export var attack_cooldown: float = 2.0
@export var health: int = 20

# --- State Flags ---
var is_awake := false
var is_waking_up := false
var can_attack := true
var is_casting := false

# --- Node References ---
@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim_player = $Skeleton_Mage/AnimationPlayer
@onready var cast_origin = $Skeleton_Mage/CastOrigin
@onready var spell_effect = preload("res://Scenes/MageSpellEffect.tscn")

# --- Sound Effects ---
@onready var walk_sfx = $WalkSFX
@onready var death_sfx = $DeathSFX
@onready var spell_sfx = $SpellSFX


func _ready():
	anim_player.play("Skeleton_Inactive_Standing_Pose")


func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	if is_awake:
		if not is_casting:
			move_towards(player.global_transform.origin, chase_speed, delta)

		if can_attack and not is_casting and is_player_in_spell_range():
			await cast_spell()
	else:
		if can_see_player() and not is_waking_up:
			await wake_up()


# --- Detection ---
func can_see_player() -> bool:
	return is_instance_valid(player) and global_position.distance_to(player.global_position) <= vision_range

func is_player_in_spell_range() -> bool:
	return global_position.distance_to(player.global_position) <= vision_range


# --- Wake-Up Animation ---
func wake_up() -> void:
	is_waking_up = true
	anim_player.play("Skeletons_Awaken_Standing")
	await anim_player.animation_finished

	anim_player.play("Walking_D_Skeletons")
	is_awake = true
	is_waking_up = false


# --- Movement Logic ---
func move_towards(target: Vector3, move_speed: float, delta: float) -> void:
	var direction = (target - global_transform.origin).normalized()
	velocity = direction * move_speed
	move_and_slide()

	# Rotate the character mesh
	if direction.length() > 0.1:
		$Skeleton_Mage.look_at(global_transform.origin + direction, Vector3.UP)
		$Skeleton_Mage.rotate_y(deg_to_rad(180))

	if not anim_player.is_playing():
		anim_player.play("Walking_D_Skeletons")


# --- Spellcasting Logic ---
func cast_spell() -> void:
	if health <= 0 or not is_instance_valid(player):
		return

	is_casting = true
	can_attack = false

	# Stop movement
	velocity = Vector3.ZERO
	move_and_slide()

	# Stop walking sound
	if walk_sfx and walk_sfx.playing:
		walk_sfx.stop()

	# Play cast animation and sound
	spell_sfx.play()
	anim_player.play("Spellcast_Shoot")
	await anim_player.animation_finished

	# Cancel spell if died during cast
	if health <= 0:
		is_casting = false
		return

	# Spawn visual effect
	var fx = spell_effect.instantiate()
	fx.global_position = cast_origin.global_position
	get_tree().current_scene.add_child(fx)

	# Apply damage if still in range
	if is_player_in_spell_range():
		player.take_damage(10)

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	is_casting = false


# --- Damage & Death ---
func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()


func die() -> void:
	if death_sfx:
		death_sfx.play()

	anim_player.play("Death_C_Skeletons")
	await anim_player.animation_finished

	# Add score to HUD
	var hud = get_tree().get_root().find_child("HUD", true, false)
	if hud:
		hud.add_score(350)

	queue_free()
