extends Node3D

@export var starting_room_scene: PackedScene  
@export var room_scenes: Array[PackedScene]= [
	preload("res://dungeonRoom.tscn")  
	]
@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

@export var max_rooms: int = 10

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

	
	await get_tree().process_frame  
	start_room.global_position = Vector3.ZERO

	spawned_rooms.append(start_room)
	used_positions[Vector3.ZERO] = true

	#  Spawn Player
	if player_scene:
		player_instance = player_scene.instantiate()

		#  Place player at the spawn point of the first room
		var spawn_point = start_room.find_child("PlayerSpawn", true, false)
		if spawn_point:
			player_instance.global_position = spawn_point.global_position
		else:
			player_instance.global_position = start_room.global_position + Vector3(0, 1, 0)

		add_child(player_instance)
		print("Player spawned at:", player_instance.global_position)
	else:
		push_error("ERROR: No player scene assigned in Inspector!")

	#  Spawn Additional Rooms
	for i in range(max_rooms - 1):
		var new_room = await spawn_room()
		if new_room:
			spawned_rooms.append(new_room)

func spawn_room() -> Node3D:
	if room_scenes.is_empty():
		push_error("ERROR: No rooms assigned to 'room_scenes' in Inspector!")
		return null  

	var selected_room = room_scenes.pick_random()
	print("Spawning Room Scene:", selected_room.resource_path)

	var new_room_instance = selected_room.instantiate()
	if not new_room_instance:
		push_error("ERROR: Failed to instantiate room!")
		return null  

	var offset = choose_random_direction()
	var new_pos = spawned_rooms[-1].global_position + offset

	if not used_positions.has(new_pos):
		new_room_instance.global_position = new_pos
		used_positions[new_pos] = true
		add_child(new_room_instance)

		print("Room placed at:", new_room_instance.global_position)

		return new_room_instance
	else:
		print("Position already occupied!")

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
