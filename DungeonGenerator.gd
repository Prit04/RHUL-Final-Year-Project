extends Node3D

@export var starting_room_scene: PackedScene  
@export var room_scenes: Array[PackedScene]  
@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

@export var max_rooms: int = 5  

var spawned_rooms = []  
var used_positions = {}  
var player_instance  

func _ready():
	await ready  
	generate_dungeon()

func generate_dungeon():
	if room_scenes.is_empty():
		push_error("⚠️ ERROR: No rooms assigned to 'room_scenes' in Inspector!")
		return  

	#  Spawn the first room
	var start_room = starting_room_scene.instantiate()
	add_child(start_room)

	# Ensure it's placed properly in the tree before setting global position
	await get_tree().process_frame  
	start_room.global_position = Vector3.ZERO

	spawned_rooms.append(start_room)
	used_positions[Vector3.ZERO] = true

	#  Spawn Player
	if player_scene:
		player_instance = player_scene.instantiate()
		player_instance.global_position = start_room.global_position + Vector3(0, 1, 0)
		add_child(player_instance)
	else:
		push_error("⚠️ ERROR: No player scene assigned in Inspector!")

	#  Spawn Additional Rooms
	for i in range(max_rooms - 1):
		var new_room = await spawn_room()
		if new_room:
			spawned_rooms.append(new_room)

func spawn_room() -> Node3D:
	var attempts = 0
	var new_room_instance

	while attempts < 10:
		if room_scenes.is_empty():
			return null  

		var random_room = room_scenes.pick_random()
		new_room_instance = random_room.instantiate()

		var offset = choose_random_direction()
		var new_pos = spawned_rooms[-1].global_position + offset

		if not used_positions.has(new_pos):
			new_room_instance.global_position = new_pos
			used_positions[new_pos] = true
			add_child(new_room_instance)

			# Assign enemy scene before linking doors
			if new_room_instance.has_method("set_enemy_scene"):
				new_room_instance.set_enemy_scene(enemy_scene)

			link_doors(spawned_rooms[-1], new_room_instance, offset)

			#  Wait before spawning enemies (ensures room is fully placed)
			await get_tree().process_frame
			if new_room_instance.has_method("spawn_enemies"):
				new_room_instance.spawn_enemies()

			print("Room placed at:", new_room_instance.global_position)
			return new_room_instance

		attempts += 1

	return null  


func link_doors(prev_room, new_room, offset):
	# Find the doors in each room
	var prev_door = get_doorway(prev_room, offset)
	var new_door = get_doorway(new_room, -offset)

	if prev_door and new_door:
		prev_door.target_room = new_door.get_path()
		new_door.target_room = prev_door.get_path()

func get_doorway(room, offset) -> Area3D:
	# Find the correct doorway based on direction
	for child in room.get_children():
		if child is Area3D:
			if offset == Vector3(10, 0, 0) and child.name == "Doorway_East":
				return child
			if offset == Vector3(-10, 0, 0) and child.name == "Doorway_West":
				return child
			if offset == Vector3(0, 0, 10) and child.name == "Doorway_North":
				return child
			if offset == Vector3(0, 0, -10) and child.name == "Doorway_South":
				return child
	return null

func choose_random_direction() -> Vector3:
	var directions = [
		Vector3(10, 0, 0),  
		Vector3(-10, 0, 0), 
		Vector3(0, 0, 10),  
		Vector3(0, 0, -10)
	]
	return directions.pick_random()
