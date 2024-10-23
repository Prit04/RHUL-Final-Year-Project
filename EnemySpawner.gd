extends Node

@export var enemy_scene: PackedScene  # Drag your enemy scene here
@export var spawn_interval: float = 3.0  # Time between spawns
@export var max_enemies: int = 5  # Max number of enemies on the map

var enemy_count = 0

func _ready():
	# Start spawning enemies periodically
	spawn_enemies()

# Function to spawn enemies
func spawn_enemies() -> void:
	while enemy_count < max_enemies:
		# Spawn an enemy at a random position
		var enemy_instance = enemy_scene.instantiate()
		
		# Set a random spawn position
		var spawn_position = Vector3(
			randf_range(-10, 10),  # X position
			0,  # Y position (ground level)
			randf_range(-10, 10)   # Z position
		)
		enemy_instance.global_position = spawn_position
		
		# Add the enemy to the scene
		add_child(enemy_instance)
		enemy_count += 1

		# Wait for the next spawn using `await`
		await get_tree().create_timer(spawn_interval).timeout
