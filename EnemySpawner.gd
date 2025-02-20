extends Node3D

@export var enemy_scene: PackedScene  
@export var spawn_interval: float = 3.0  
@export var max_enemies: int = 3  # Set per-room enemy limit

var enemy_count = 0
var spawn_points = []  # List of enemy spawn points

func _ready():
	# Get all enemy spawn points in the room
	spawn_points = get_tree().get_nodes_in_group("enemy_spawns")
	
	# If there are spawn points, start spawning
	if not spawn_points.is_empty():
		start_spawning()

# Function to spawn enemies periodically
func start_spawning() -> void:
	while enemy_count < max_enemies:
		await get_tree().create_timer(spawn_interval).timeout  # Wait before spawning

		var enemy_instance = enemy_scene.instantiate()
		
		# Pick a random spawn point
		var spawn_point = spawn_points.pick_random()
		enemy_instance.global_position = spawn_point.global_position

		# Add the enemy to the scene
		add_child(enemy_instance)
		enemy_count += 1

		# Connect enemy death signal to reduce count
		if enemy_instance.has_method("die"):
			enemy_instance.died.connect(_on_enemy_died)

func _on_enemy_died():
	enemy_count -= 1
