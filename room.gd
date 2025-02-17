extends Node3D

@export var exit_target: Vector3  # Set where the transition leads

func _ready():
	var exit_portal = $ExitPortal  # Get the Area3D
	if exit_portal:
		exit_portal.body_entered.connect(_on_exit_portal_entered)

func _on_exit_portal_entered(body):
	if body is CharacterBody3D:
		print("Player entered exit portal")
		body.global_position = exit_target  # Move the player
