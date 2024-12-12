extends CanvasLayer

func update_health(current_health: int, max_health: int) -> void:
	# Set the health value on the progress bar
	$TextureProgressBar.value = current_health
	# Update the health label text with the current and max values
	$Label.text = "Health: %d / %d" % [current_health, max_health]
