extends Node3D

@export var exit_target: Vector3  # Where the player moves when exiting
@export var enemy_scene: PackedScene  # Enemy scene to spawn
@export var max_enemies: int = 3  # Maximum enemies per room

var enemies_spawned = false  # Prevents double spawning

func _ready():
	var exit_portal = $ExitPortal
	if exit_portal:
		exit_portal.body_entered.connect(_on_exit_portal_entered)

	# Delayed check instead of running spawn_enemies() in _ready()
	await get_tree().process_frame
	check_enemy_spawn()

func _on_exit_portal_entered(body):
	if body is CharacterBody3D:
		print("Player entered exit portal")
		body.global_position = exit_target

# Function that waits for enemy_scene to be set
func check_enemy_spawn():
	if enemy_scene != null and not enemies_spawned:
		print("Enemy scene detected, spawning enemies...")
		spawn_enemies()
		enemies_spawned = true  # Prevents multiple spawns
	else:
		print("Waiting for enemy_scene to be set...")  # Debugging

#  Function to spawn enemies in this room
func spawn_enemies():
	if enemy_scene == null:
		print("No enemy scene assigned when spawning!")
		return

	var spawn_points = get_tree().get_nodes_in_group("enemy_spawns")
	
	#  Ensure spawn points belong to this specific room
	spawn_points = spawn_points.filter(func(spawn_point): return spawn_point.get_parent() == self)

	if spawn_points.is_empty():
		print("No valid enemy spawn points found in this room:", self.name, " at ", self.global_position)
		return  

	print("Spawning enemies in Room:", self.name, "at", self.global_position)

	var enemy_count = randi_range(1, max_enemies)
	for i in range(enemy_count):
		var spawn_point = spawn_points.pick_random()
		var enemy = enemy_scene.instantiate()
		enemy.global_position = spawn_point.global_position
		add_child(enemy)

		print("Enemy spawned at:", enemy.global_position, " in Room:", self.name)



func set_enemy_scene(scene: PackedScene):
	print(" Assigning enemy scene in set_enemy_scene()")
	enemy_scene = scene
	check_enemy_spawn()  
