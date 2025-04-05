extends Control

## --- Options Menu Script ---
## Handles changes to audio and video settings via UI sliders and toggles.

# --- UI References ---
@onready var master_slider = find_child("MasterSlider", true, false)
@onready var music_slider = find_child("MusicSlider", true, false)
@onready var sfx_slider = find_child("SFXSlider", true, false)

@onready var fullscreen_check = $VBoxContainer/FullscreenCheck
@onready var vsync_check = $VBoxContainer/VSyncCheck
@onready var back_button = $VBoxContainer/BackButton
@onready var click_player = $ClickPlayer


func _ready() -> void:
	# Initializes the options menu and applies saved settings to UI
	$AnimationPlayer.play("fade_in")

	# Apply saved settings to sliders and toggles
	master_slider.value = Settings.master_volume
	music_slider.value = Settings.music_volume
	sfx_slider.value = Settings.sfx_volume
	fullscreen_check.button_pressed = Settings.fullscreen
	vsync_check.button_pressed = Settings.vsync

	# Connect signals to update settings live
	master_slider.value_changed.connect(_on_volume_changed)
	music_slider.value_changed.connect(_on_volume_changed)
	sfx_slider.value_changed.connect(_on_volume_changed)
	fullscreen_check.toggled.connect(_on_video_setting_changed)
	vsync_check.toggled.connect(_on_video_setting_changed)
	back_button.pressed.connect(_on_back_button_pressed)


func _on_volume_changed(_val: float) -> void:
	# Updates volume settings based on slider values
	Settings.master_volume = master_slider.value
	Settings.music_volume = music_slider.value
	Settings.sfx_volume = sfx_slider.value
	Settings.apply_audio_settings()
	Settings.save_settings()


func _on_video_setting_changed(_pressed: bool) -> void:
	# Updates fullscreen and vsync based on toggles
	Settings.fullscreen = fullscreen_check.button_pressed
	Settings.vsync = vsync_check.button_pressed
	Settings.apply_video_settings()
	Settings.save_settings()


func _on_back_button_pressed() -> void:
	# Handles return to previous menu with transition
	click_player.play()
	await click_player.finished
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	queue_free()
