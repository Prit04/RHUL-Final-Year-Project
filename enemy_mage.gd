extends CharacterBody3D

@export var chase_speed := 2.0
@export var vision_range := 10.0
@export var attack_cooldown := 2.0
@export var health := 20

var is_awake := false
var is_waking_up := false
var can_attack := true
var is_casting := false  

@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim_player = $Skeleton_Mage/AnimationPlayer
@onready var cast_origin = $Skeleton_Mage/CastOrigin
@onready var spell_effect = preload("res://MageSpellEffect.tscn")
@onready var walk_sfx = $WalkSFX
@onready var death_sfx = $DeathSFX
@onready var spell_sfx = $SpellSFX

func _ready():
	anim_player.play("Skeleton_Inactive_Standing_Pose")  

func _physics_process(delta):
	if not is_instance_valid(player):
		return

	if is_awake:
		# Only move if not casting
		if not is_casting:
			move_towards(player.global_transform.origin, chase_speed, delta)

		# Only cast when not already casting and in range
		if can_attack and not is_casting and is_player_in_spell_range():
			await cast_spell()
	else:
		if can_see_player() and not is_waking_up:
			await wake_up()

func can_see_player() -> bool:
	return is_instance_valid(player) and global_position.distance_to(player.global_position) <= vision_range

func is_player_in_spell_range() -> bool:
	return global_position.distance_to(player.global_position) <= vision_range

func wake_up():
	is_waking_up = true
	anim_player.play("Skeletons_Awaken_Standing")
	await anim_player.animation_finished
	anim_player.play("Walking_D_Skeletons")
	is_awake = true
	is_waking_up = false

func move_towards(target: Vector3, move_speed: float, delta: float):
	var direction = (target - global_transform.origin).normalized()
	velocity = direction * move_speed
	move_and_slide()

	# Rotate toward movement direction
	if direction.length() > 0.1:
		$Skeleton_Mage.look_at(global_transform.origin + direction, Vector3.UP)
		$Skeleton_Mage.rotate_y(deg_to_rad(180))

	if not anim_player.is_playing():
		anim_player.play("Walking_D_Skeletons")

func cast_spell():
	if health <= 0 or player == null or not is_instance_valid(player):
		return  

	is_casting = true
	can_attack = false

	velocity = Vector3.ZERO
	move_and_slide()

	if walk_sfx and walk_sfx.playing:
		walk_sfx.stop()

	spell_sfx.play()
	anim_player.play("Spellcast_Shoot")
	await anim_player.animation_finished

	if health <= 0:
		is_casting = false
		return

	# Spell effect
	var fx = spell_effect.instantiate()
	fx.global_position = cast_origin.global_position
	get_tree().current_scene.add_child(fx)

	# Check hit
	if is_player_in_spell_range():
		player.take_damage(10)
		print("Player hit by mage spell!")

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	is_casting = false


func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	if death_sfx:
		death_sfx.play()
	anim_player.play("Death_C_Skeletons")
	await anim_player.animation_finished
	var hud = get_tree().get_root().find_child("HUD", true, false)
	if hud:
		hud.add_score(350)
	else:
		print("HUD not found! Score not updated.")
	queue_free()
