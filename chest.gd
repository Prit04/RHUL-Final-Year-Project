extends StaticBody3D

@export var chest_value := 750
var is_open := false

func interact():
	if is_open:
		return

	is_open = true
	print("Chest opened! Gained", chest_value, "points.")
	$AnimationPlayer.play("open")
	if has_node("ChestOpenSound"):
		$ChestOpenSound.play()

	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("add_score"):
		hud.add_score(chest_value)
	else:
		print("HUD not found or 'add_score' method missing!")
