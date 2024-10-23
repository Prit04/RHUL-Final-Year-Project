extends CharacterBody3D

# Enemy stats
var health = 50
var speed = 2.0

# Movement variables
var move_direction = Vector3.ZERO

func _ready():
	randomize_direction()

func _process(delta):
	# Set velocity based on movement direction
	velocity = Vector3(move_direction.x * speed, velocity.y, move_direction.z * speed)

	# Move the enemy using the built-in velocity
	move_and_slide()

	# If health reaches zero, destroy the enemy
	if health <= 0:
		queue_free()

# Randomize the movement direction of the enemy
func randomize_direction():
	move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()

# Take damage when hit
func take_damage(amount):
	health -= amount
