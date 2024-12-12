extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the "pressed" signal of the BackButton to the appropriate function
	$BackButton.connect("pressed", Callable(self, "_on_BackButton_pressed"))


func _on_BackButton_pressed():
	 # Change the current scene to the specified target scene
	get_tree().change_scene_to_file("res://control.tscn")
