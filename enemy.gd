extends CharacterBody3D

# Enemy attributes
var health = 50
var speed = 2.0

# Attack attributes
var attack_damage = 10
var attack_range = 2.0
var attack_cooldown = 1.0
var can_attack: bool = true

# Reference to the player
@onready var player = get_node("/root/StaticBody3D/Player")

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player) or player.is_dead:
		return
	move_towards_player(delta)
	if is_player_in_range():
		attack_player()

func is_player_in_range() -> bool:
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	return distance_to_player <= attack_range


func move_towards_player(delta: float) -> void:
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y = 0
	move_and_slide()
	
func attack_player() -> void:
	if can_attack:
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
	queue_free()
