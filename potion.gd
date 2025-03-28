extends StaticBody3D

@export var heal_amount: int = 20
var used = false

func interact():
	if used:
		return

	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("heal"):
		player.heal(heal_amount)
		print("Potion used! Healed for", heal_amount, "HP.")
		used = true
		queue_free()  # remove potion from scene 
