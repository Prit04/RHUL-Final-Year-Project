extends Node3D 

@onready var torch_light := $OmniLight3D  

var rng = RandomNumberGenerator.new()

# Flicker range
@export var base_energy := 3.194
@export var flicker_intensity := 0.9
@export var flicker_speed := 0.05



func _ready():
	rng.randomize()
	_start_flicker()


func _start_flicker():
	flicker_loop()


func flicker_loop():
	while true:
		var flicker = base_energy + rng.randf_range(-flicker_intensity, flicker_intensity)
		torch_light.light_energy = flicker
		await get_tree().create_timer(flicker_speed).timeout
