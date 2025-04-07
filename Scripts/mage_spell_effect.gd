extends Node3D

## --- Mage Spell Visual Effect Script ---
## A temporary effect that plays when the mage attacks. Auto-deletes after a short delay.

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	queue_free()
