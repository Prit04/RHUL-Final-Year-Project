extends Area3D

@export var target_room: NodePath  # The room this door leads to
@export var is_locked: bool = false  # If true, the door stays closed

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody3D:
		if is_locked:
			print("Door is locked!")
			return  # Prevents movement if door is locked

		print("Player entered doorway! Transitioning...")
		transition_to_next_room(body)

func transition_to_next_room(body):
	var target = get_node_or_null(target_room)
	if target:
		body.global_position = target.global_position + Vector3(0, 1, 0)
