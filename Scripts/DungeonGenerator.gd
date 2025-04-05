extends Node3D

## --- Dungeon Generator Script ---
## Handles procedural dungeon generation, room linking, player/enemy/pickup spawning,
## door connection, and game setup.

# --- Editor Exports ---
@export var starting_room_scene: PackedScene
@export var room_scenes: Array[PackedScene] = [
	preload("res://Scenes/dungeonRoom.tscn"),
	preload("res://Scenes/room_trap.tscn")
]
@export var player_scene: PackedScene
@export var enemy_scene: PackedScene
@export var chest_scene: PackedScene
@export var potion_scene: PackedScene
@export var max_rooms: int = 12
@export var max_trap_rooms: int = 2
@export var max_chest_rooms: int = 4
@export var max_potions: int = 4

## --- Internal State ---
var chest_room_count: int = 0
var trap_room_count: int = 0
var potions_spawned: int = 0
var spawned_rooms: Array[Node3D] = []
var used_positions := {}
var player_instance: Node3D

## --- Scene Nodes ---
@onready var pause_menu = $PauseMenu
@onready var game_over = $GameOver


func _ready():
	cleanup_dungeon()                          # Clean up old dungeon before creating a new one
	await ready  
	generate_dungeon()
	
# --- Pause Handling
func _unhandled_input(event):
	if event.is_action_pressed("pause") and pause_menu:
		pause_menu.toggle_pause()

# --- Main Dungeon Generation ---
func generate_dungeon():
	if room_scenes.is_empty():
		push_error("ERROR: No rooms assigned to 'room_scenes' in Inspector!")
		return  

	# Spawn the first room
	var start_room = starting_room_scene.instantiate()
	add_child(start_room)
	await get_tree().process_frame  
	start_room.global_position = Vector3.ZERO
	spawned_rooms.append(start_room)
	used_positions[Vector3.ZERO] = true

	# Spawn Player
	if player_scene:
		player_instance = player_scene.instantiate()

		# Place player at the spawn point of the first room
		var spawn_point = start_room.find_child("PlayerSpawn", true, false)
		if spawn_point:
			player_instance.global_position = spawn_point.global_position
		else:
			player_instance.global_position = start_room.global_position + Vector3(0, 1, 0)

		add_child(player_instance)
	else:
		push_error("ERROR: No player scene assigned in Inspector!")

	# Spawn Additional Rooms
	for i in range(max_rooms - 1):
		var new_room = await spawn_room()
		if new_room:
			spawned_rooms.append(new_room)

# --- Room Spawning ---
func spawn_room() -> Node3D:
	if room_scenes.is_empty():
		push_error("ERROR: No rooms assigned to 'room_scenes' in Inspector!")
		return null  
		
	var selected_room = room_scenes.pick_random()
	var new_room_instance = selected_room.instantiate()
	if not new_room_instance:
		push_error("ERROR: Failed to instantiate room!")
		return null  

	var room_size = get_room_size(new_room_instance)
	var offset = choose_valid_room_offset(room_size)
	var new_pos = spawned_rooms[-1].global_position + offset  

	# Snap to grid
	new_pos.x = snapped(new_pos.x, room_size.x)  
	new_pos.z = snapped(new_pos.z, room_size.z)  

	if not used_positions.has(new_pos) and detect_open_door(spawned_rooms[-1]):
		new_room_instance.global_position = new_pos
		used_positions[new_pos] = true
		add_child(new_room_instance)
		await get_tree().process_frame 

		# Spawn enemies inside this room
		spawn_enemies_in_room(new_room_instance)
		spawn_potion_in_room(new_room_instance)

	if chest_scene and chest_room_count < max_chest_rooms and spawned_rooms.size() >= 1:
		if spawn_chest_in_room(new_room_instance):
			chest_room_count += 1

		link_doors(spawned_rooms[-1], new_room_instance, offset)

		return new_room_instance
	
	return null

# --- Chest Spawning ---
func spawn_chest_in_room(room: Node3D) -> bool:
	var spawn_point = room.find_child("ChestSpawn", true, false)
	if spawn_point:
		var chest_instance = chest_scene.instantiate()
		chest_instance.global_transform.origin = spawn_point.global_transform.origin
		room.add_child(chest_instance)
		return true
	else:
		return false

# --- Enemy Spawning ---
func spawn_enemies_in_room(room: Node3D):
	await get_tree().process_frame             # Wait for room to finish placing

	var spawn_container = room.find_child("EnemySpawnPoints", true, false)
	if spawn_container:
		var spawn_points = spawn_container.get_children()
		spawn_points = spawn_points.filter(func(p): return p is Marker3D or p is Node3D)
		spawn_points.shuffle()

		var enemies_to_spawn = min(2, spawn_points.size())
		for i in range(enemies_to_spawn):
			if enemy_scene:
				var enemy_instance = enemy_scene.instantiate()
				var spawn_point = spawn_points[i]

				room.add_child(enemy_instance)
				enemy_instance.global_transform.origin = spawn_point.global_transform.origin

# --- Potion Spawnining ----
func spawn_potion_in_room(room: Node3D):
	if potions_spawned >= max_potions or potion_scene == null:
		return

	await get_tree().process_frame

	var spawn_container = room.find_child("PotionSpawnPoints", true, false)
	if spawn_container:
		var spawn_points = spawn_container.get_children()
		spawn_points = spawn_points.filter(func(p): return p is Marker3D or p is Node3D)
		spawn_points.shuffle()

		if spawn_points.size() > 0:
			var spawn_point = spawn_points[0]
			var potion = potion_scene.instantiate()
			room.add_child(potion)
			potion.global_transform.origin = spawn_point.global_transform.origin
			potions_spawned += 1

# --- Valid Room Offset
func choose_valid_room_offset(room_size: Vector3) -> Vector3:
	var possible_directions = [
		Vector3(room_size.x, 0, 0),  
		Vector3(-room_size.x, 0, 0), 
		Vector3(0, 0, room_size.z),  
		Vector3(0, 0, -room_size.z)
	]

	possible_directions.shuffle()              # Randomize order

	for direction in possible_directions:
		var new_pos = spawned_rooms[-1].global_position + direction

		# Check if the position is already occupied
		if not used_positions.has(new_pos) and detect_open_door(spawned_rooms[-1]):
			return direction                   # Return the first available valid position

	return possible_directions.pick_random()  

func detect_open_door(room: Node3D) -> bool:
	var found_door = false

	# Loop through all children, including nested ones
	for child in room.get_children():
		if child is Node3D:                    # If it's a parent, search inside it
			for sub_child in child.get_children():
				if sub_child is Area3D and sub_child.is_in_group("doorways"):
					found_door = true

	if not found_door:
		print("No valid doors found in room:", room.name)
	return found_door

# --- Door Connection ---
func link_doors(prev_room, new_room, offset):
	var prev_door = get_doorway(prev_room, offset)
	var new_door = get_doorway(new_room, -offset)

	if prev_door and new_door:
		prev_door.set_meta("linked_room", new_door)
		new_door.set_meta("linked_room", prev_door)

# --- Door Finding ---
func get_doorway(room: Node3D, offset: Vector3) -> Area3D:
	var doors = room.find_children("", "Area3D", true)
	for door in doors:
		if door.is_in_group("doorways"):
			match offset:
				Vector3(25, 0, 0): if door.name == "Doorway_East": return door
				Vector3(-25, 0, 0): if door.name == "Doorway_West": return door
				Vector3(0, 0, 25): if door.name == "Doorway_North": return door
				Vector3(0, 0, -25): if door.name == "Doorway_South": return door
	return null

# --- Room Size Check ---
func get_room_size(room: Node3D) -> Vector3:
	for child in room.get_children():
		if child is CollisionShape3D and child.name == "RoomBounds":
			var shape = child.shape as BoxShape3D
			if shape:
				var size = shape.extents * 2
				return size
	return Vector3(10, 0, 10)

	

# --- Cleanup Dungeon ---
func cleanup_dungeon():
	for room in spawned_rooms:
		if is_instance_valid(room):
			room.queue_free()
	spawned_rooms.clear()
	used_positions.clear()
	trap_room_count = 0
