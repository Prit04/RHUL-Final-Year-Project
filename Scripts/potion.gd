extends StaticBody3D

## --- Healing Potion Script ---
## Heals the player when interacted with. Plays a drink sound and disappears after a short delay.

@export var heal_amount: int = 20       # Amount of health restored
var used: bool = false                  # Prevents re-use

func interact() -> void:
	if used:
		return

	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("heal"):
		player.heal(heal_amount)
		print("Potion used! Healed for", heal_amount, "HP.")

		# Play drink sound if available
		if has_node("PotionDrinkSound"):
			$PotionDrinkSound.play()

		used = true
		await get_tree().create_timer(1.35).timeout
		queue_free()  # Remove the potion after sound plays
