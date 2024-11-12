extends CanvasLayer

func update_health(current_health: int, max_health: int) -> void:
	$TextureProgressBar.value = current_health
	$Label.text = "Health: %d / %d" % [current_health, max_health]
