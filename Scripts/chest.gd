extends StaticBody3D

## -- Chest Logic Script --
## Handles chest interactions: animation, sound, and score update on player interaction.

@export var chest_value := 750  # Score awarded when chest is opened
var is_open := false            # Prevents multiple interactions

# Called when the player interacts with the chest
func interact():
	if is_open:
		return  # Already opened, skip

	is_open = true

	# Play chest open animation
	if $AnimationPlayer:
		$AnimationPlayer.play("open")

	# Play open sound 
	if has_node("ChestOpenSound"):
		$ChestOpenSound.play()

	# Update the HUD score
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("add_score"):
		hud.add_score(chest_value)
