extends CharacterBody3D

var health = 50
var speed = 2.0
var attack_damage = 10
var detection_range = 10.0
var attack_range = 2.0
var attack_cooldown = 1.0
var can_attack = true

# Reference to the player
onready var player = get_tree().get_root().get_node("Player")  

func _physics_process(delta):
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_range:
			# Attack the player
			attack_player()
			velocity = Vector3.ZERO  # Stop moving when attacking
		elif distance_to_player <= detection_range:
			move_towards_player(delta)
		else:
			# Idle or random movement
			random_movement(delta)
	else:
		player = get_tree().get_root().get_node("Player")
		
	velocity.y += ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	move_and_slide()

func move_towards_player(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func random_movement(delta):
	# Implement random movement or keep the enemy idle
	velocity.x = 0
	velocity.z = 0

func attack_player():
	if can_attack:
		player.take_damage(attack_damage)
		can_attack = false
		# Start the attack cooldown
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

# Take damage when hit
func take_damage(damage):
	health -= damage
	if health <= 0:
		die()
		
func die():
	queue_free()
