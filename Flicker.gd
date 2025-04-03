extends Node3D

## --- Torch Flicker Effect Script ---
## --- Applys a flicker effect to the torches using randomisation ---

## --- Torch Flicker Settings ---
@onready var torch_light := $OmniLight3D
var rng := RandomNumberGenerator.new()

@export var base_energy := 3.194          # Base brightness of the torch
@export var flicker_intensity := 0.9      # Max +/- brightness variance
@export var flicker_speed := 0.05         # Time between flickers (in seconds)


func _ready() -> void:
	rng.randomize()
	_start_flicker()


func _start_flicker() -> void:
	flicker_loop()


func flicker_loop() -> void:
	while true:
		var flicker_value = base_energy + rng.randf_range(-flicker_intensity, flicker_intensity)
		torch_light.light_energy = flicker_value
		await get_tree().create_timer(flicker_speed).timeout
