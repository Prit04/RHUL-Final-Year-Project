extends CharacterBody3D

# Enemy attributes
var health = 50
var speed = 2.0

# Attack attributes
var attack_damage = 10
var attack_range = 2.0
var attack_cooldown = 1.0
var can_attack: bool = true

signal died  # New signal to tell spawner when an enemy dies

# Reference to the player
@onready var player = get_tree().get_first_node_in_group("player")  # Dynamic reference

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player) or player.is_dead:
		return
	move_towards_player(delta)
	if is_player_in_range():
		attack_player()

func is_player_in_range() -> bool:
	if not is_instance_valid(player):
		return false
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	return distance_to_player <= attack_range

func move_towards_player(delta: float) -> void:
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	
	# Prevent movement if there's an obstacle
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, player.global_position)
	var result = space_state.intersect_ray(query)
	
	if result.is_empty():
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		velocity.y = 0
		move_and_slide()

func attack_player() -> void:
	if can_attack:
		if is_instance_valid(player):
			player.take_damage(attack_damage)
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

# Take damage when hit
func take_damage(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	died.emit()  # Notify spawner this enemy is dead
	queue_free()
